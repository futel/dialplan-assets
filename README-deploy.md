# Deploy dialplan assets

We store assets in S3. We don't version the assets, we only have one collection which all dialplan installations access.

Dialplan functions should be set up (after this component) as described in dialplan-functions README-deploy.

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

Have asset directory tree in asset_src.

# Setup

To be done once.

## Set up S3

Set up S3 as in README-aws.

## Set up environment secrets

Fill src/.env to match src/.env.sample as described in README-aws.

## Set up virtualenv

In src:

    python3 -m venv venv
    
    source venv/bin/activate

    pip install -r requirements.txt

# Deploy

## Provision/transform assets

    ansible-playbook deploy/update_assets.yml

## Copy assets to S3

In src:

    source venv/bin/activate
    
    python run.py

## Update Digital Ocean Function components to point to URLs

The asset host is dialplan-assets.s3.us-west-2.amazonaws.com.

The current process will not result in a new bucket. If the bucket is new, update the Digital ocean .env file to point to the asset host as described in do-functions README-deploy.

# Notes

The asset host is built from the bucket name and AWS region. The bucket name is hardcoded in the deployment config and/or source, and the region is set by AWS configuration. We don't intend to change the bucket name, instead, all assets needed by all installations must be in the bucket. If we need to change the bucket name, we will need to deploy a second bucket, and then deploy dialplan-functions with the new asset host.
