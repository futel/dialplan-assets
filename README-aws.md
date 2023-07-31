# AWS requirements

Create AWS user dialplan-assets
(the permissions and groups are probably not needed?)
description: asset deployment
permissions policies:
- s3-get-put-delete
- s3 list-bucket-content
groups:
- s3-writers

Create S3 bucket
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

etc etc
