#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


# https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats
# https://support.twilio.com/hc/en-us/articles/223180588-Best-Practices-for-Audio-Recordings
# The telephony standard is 8-bit PCM mono uLaw with a sampling rate of 8Khz. Since this telephony format is fixed, any audio file uploaded to Twilio will be transcoded to that telephony standard. That standard is bandwidth-limited to the 300Hz - 8Khz audio range and is designed for voice and provides acceptable voice-quality results. This standard isn't suitable for quality music reproduction but will provide minimally acceptable results.

require 'find'
require 'fileutils'
require 'sndfile'

OUTPUT_MP3 = false #make true if we want to re-encode mp3s as mp3 for the output
SOX_COMPAND = "compand 0.001,0.3 6:-30,-3 -6 -12 0.002"

SRC_DIR = ARGV[0]
DEST_DIR = ARGV[1]

puts "updating #{DEST_DIR} with audio from #{SRC_DIR}"

script_mtime = File.mtime(__FILE__)

Find.find(SRC_DIR).each do |f|
  is_raw = true
  out_ext = 'ulaw'

  cleanup = []
  next if File.directory?(f)

  src = f

  #create the destination path
  f = f.split("/").last
  dst = File.join(DEST_DIR, f)
  base = File.join(File.dirname(dst), File.basename(dst, ".*"))

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #convert mp3 to wav and use the info for the destination
  src_ext = File.extname(src)
  if src_ext == ".mp3"
    if OUTPUT_MP3
      out_ext = 'mp3'
      is_raw = false
    end
  end

  dst = base + "." + out_ext
  puts "#{src} -> #{dst}"

  # Combined signal chain (order is important):
  # * Convert to single channel (monophonic)
  # * Apply band filter from 300 Hz to 3.4kHz
  # * Normalize amplitude to -12dB RMS (with limiting to not clip)
  # * Convert sample rate to 8kHz
  # * Dynamic range compression
  processed = base + "-tmp-processed.wav"
  raise "failed to filter audio" unless system("sox #{src} #{processed} channels 1 sinc 300-3700 gain -n -b -12 rate 8000 #{SOX_COMPAND} :")
  cleanup << processed
  src = processed

  #remove header if it is raw
  if is_raw
    raw = base + "-tmp.raw"
    raise "cannot create raw encoding" unless system("sndfile-convert", "-ulaw", src, raw)
    cleanup << raw
    src = raw
  elsif out_ext == ".mp3" and OUTPUT_MP3 #convert back to mp3
    mp3 = base + "-tmp-mp3.mp3"
    raise "failed to encode to mp3" unless system("lame", "--quiet", src, mp3)
    src = mp3
    cleanup << mp3
  else
    raise "don't know what to do with #{src} -> #{dst}"
  end

  #copy to the final location
  FileUtils.copy(src, dst)

  #cleanup
  cleanup.each { |f| File.unlink(f) }
end

