# Deploy dialplan assets

We store assets in S3. We don't version the assets, we only have one collection which all dialplan installations access.

Dialplan functions should be set up (after this component) as described in dialplan-functions DEPLOY.md.

# Meta-requirements

Set up S3 as in aws.md.

Have asset directory tree in assets_src.

# Requirements

- debian box (trixie, ubuntu 23)
- apt packages
  - ansible-core
  - gcc
  - g++
  - lame
  - libffi-dev
  - libgsl-dev
  - libsndfile-dev
  - libsox-fmt-mp3
  - make
  - nodejs
  - npm
  - pkg-config
  - ruby-dev
  - normalize-audio
  - sndfile-programs
  - sox
  - Twilio CLI 5.16 or equivalent eg local/twilio-5.16.0-amd64.deb
- ruby gems    
  - sndfile
  - yard

# Setup

To be done once.

## Set up environment secrets

Fill src/.env to match src/.env.sample as described in aws.md.

## Set up virtualenv

- cd src
- python3 -m venv venv
- source venv/bin/activate
- pip install -r requirements.txt

# Deploy

## Provision/transform assets

- ansible-playbook deploy/update_assets.yml

## Copy assets to S3

In src:

- source venv/bin/activate
- python3 run.py

## Update DigitalOcean Function components to point to URLs

The asset host is dialplan-assets.s3.us-west-2.amazonaws.com.

The current process will not result in a new bucket. If the bucket is new, update the DigitalOcean .env file to point to the asset host as described in dialplan-functions DEPLOY.md

# Notes

The asset host is built from the bucket name and AWS region. The bucket name is hardcoded in the deployment config and/or source, and the region is set by AWS configuration. We don't intend to change the bucket name, instead, all assets needed by all installations must be in the bucket. If we need to change the bucket name, we will need to deploy a second bucket, and then deploy dialplan-functions with the new asset host.
