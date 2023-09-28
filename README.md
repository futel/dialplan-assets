# Deploy dialplan assets

We store assets in S3. We don't version the assets, we only have one collection which all dialplan installations access.

Digital Ocean Functions should be set up (after this component) as described in do-functions README-deploy.

# Setup

To be done once.

## Set up S3

Set up S3 as in README-aws.

## Set up environment secrets

Fill src/.env to match src/.env.sample as described in README-aws.

## Set up virtualenv

In src:

    virtualenv env
    
    source env/bin/activate

    pip install -r requirements.txt

## Set up assets

Copy content directory tree into asset_src.

# Deploy

## Provision/transform assets

    ansible-playbook deploy/update_assets.yml

## Copy assets to S3

In src:

    source env/bin/activate
    
    python run.py

## Update Digital Ocean Function components to point to URLs

The asset host is dialplan-assets.s3.us-west-2.amazonaws.com.

The current process will not result in a new bucket. If the bucket is new, update the Digital ocean .env file to point to the asset host as described in do-functions README-deploy.

# Notes

The asset host is built from the bucket name and AWS region. The bucket name is hardcoded in the deployment config and/or source, and the region is set by AWS configuration. We don't intend to change the bucket name, instead, all assets needed by all installations must be in the bucket. If we need to change the bucket name, we will need to deploy a second bucket, and then deploy dialplan-functions with the new asset host.

# Content credits

en/outgoing Rose Howell 2023
en/utilities Tishbite
es/outgoing Sofia
es/utilities Sofia
