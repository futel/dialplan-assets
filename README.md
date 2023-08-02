# Deploy dialplan assets

We store assets in S3. We don't version the assets, we only have one collection which all dialplan installations access.

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

# Deploy

Copy assets directory tree into asset_src.

## Provision/transform assets

    ansible-playbook deploy/update_assets.yml

## Copy assets to S3

In src:

    source env/bin/activate
    
    python src/run.sh
