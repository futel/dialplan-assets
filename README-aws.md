# AWS requirements

## Create dialplan-assets AWS user

(the permissions and groups are probably not needed?)
description: asset deployment
permissions policies:
- s3-get-put-delete
- s3 list-bucket-content
groups:
- s3-writers

## Create dialplan-assets S3 bucket

name: dialplan-assets
aws region: us-west-2
object ownership: acls disabled
block public access settings: allow all
bucket policy:
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "statement1",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::168594572693:user/dialplan_assets"
			},
			"Action": "*",
			"Resource": [
                 "arn:aws:s3:::dialplan-assets/*",
                 "arn:aws:s3:::dialplan-assets"
            ]
		},
		{
			"Sid": "statement2",
			"Effect": "Allow",
			"Principal": {
				"AWS": "*"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::dialplan-assets/*"
		}
	]
}

## Create dialplan-assets-logs S3 bucket

name: dialplan-assets-logs
copy settings from existing bucket: dialplan-assets
aws region: us-west-2
object ownership: acls disabled
block public access settings: block all

## Set up server access logging for dialplan-assets S3 bucket

In the web console:
- properties:server access logging:edit
- destination s3://dialplan-assets-logs
- XXX how do we need to maintain these? Delete old logs?
