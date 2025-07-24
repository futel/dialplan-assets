# dialplan-assets

Asset server for Futel deployments, implemented with AWS S3.

Interfaces with
- twilio-sip-server (HTTP)
Requires
- dialplan-functions

# Overview

We are deploying audio files in AWS S3. They will be retrieved and used by Twilio Programmable Voice. The TwiML used by Twilio Programmable Voice, served by dialplan-assets, references the URLs.


