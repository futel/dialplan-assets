import os
import shutil
import sys

def pop_dot_dirs(filename):
    filename = filename.split('/')
    while filename[0] == '..':
        filename.pop(0)
    return '/'.join(filename)

def pop_dir(filename):
    filename = filename.split('/')
    filename.pop(0)
    return '/'.join(filename)

def filenames(rootdir):
    """Yield (path, filename) tuples for all files in rootdir."""
    for folder, subs, files in os.walk(rootdir):
        for filename in files:
            dest_folder = pop_dot_dirs(folder)
            dest_folder = pop_dir(dest_folder)
            yield (
                '/'.join((folder, filename)),
                '.'.join(dest_folder.split('/') + [filename]))

def copy_filenames(filename_tuples, destdir):
    for path, filename in filename_tuples:
        shutil.copyfile(path, '/'.join((destdir, filename)))

if __name__ == '__main__':
    src_dirname = sys.argv[1]
    dest_dirname = sys.argv[2]
    filename_tuples = filenames(src_dirname)
    copy_filenames(filename_tuples, dest_dirname)
