# Deploy dialplan assets

We store assets in a Twilio Programmable Voice Service. We don't version the assets, we only have one collection which all dialplan installations access.

Dialplan functions should be set up (after this component) as described in dialplan-functions README-deploy.

# Requirements

## Twilio requirements

The dialplan-assets service must have been created. Have its SID.

## Local requirements

Have content directory tree in asset_src.

Have packages (on an Ubuntu system):

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

Have ruby gem:
- sndfile

# Setup

To be done once.

## Set up Twilio creds

    twilio login

## Set up service

    cd service

    twilio serverless:deploy --no-functions

XXX change service name

# Deploy

## Set up assets

Have content directory tree in asset_src.

## Provision/transform assets

    ansible-playbook deploy/update_assets.yml

## Copy assets to service

    cd service

    twilio serverless:deploy --no-functions

XXX change service name

## Prune assets on service

XXX Assets get undeployed but may still count against resource limits?

# Delete service

Don't do this, since we only have one asset service!

    twilio api:serverless:v1:services:remove \
    --sid <SID>

## Update Digital Ocean Function components to point to URLs

The domain was given with the deploy command, eg foo-1092-dev.twil.io, and is shown in the web console for the service, or there's some twilio list command.

The current process will not result in a new domain. If the domain is new, update the dialplan .env file to point to the domain as described in dialplan-functions README-deploy.

# Notes

We don't intend to version the domain, instead, all assets needed by all installations must be served. If we need to change the domain, we will need to deploy a second domain, and then deploy dialplan-functions with the second domain.
