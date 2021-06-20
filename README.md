# mt-auto-alert

This Project automatically sets up Cloudwatch alert on CPU Utilization of EC2 instance based on the threshold specified in the ec2 tags.


Following are the Prerequisites:

1. Terraform should be installed and should have access to provision infrastructure (either using Secret keys or AWS IAM Role if you are running this from ec2 instance).
2. Some changes needs to be made in the file templates/main.tf as per the instructions mentioned in the Installation.


## What All will be created?

* Lambda Function per region
* CloudWatch Event Rules per region
* SNS topics
* Cloudtrail per region
* S3 Buckets
* IAM Roles for Lambda funtions

## Installation

Step 1. Clone this Repository

Step 2. In templates/main.tf, change the following:
  *  The Backend path mentioned as of now is "/Users/Aditya/state/folder/terraform.tfstate", you have to change it to the location you want to save the state file to. Please follow the format "\<your location\>/folder/terraform.tfstate"

Step 3 (optional). If You have already enabled Cloudtrail in your account, you can either comment everything in cloudtrail.tf file for delete it.

Step 4. Just run the bash script: script.sh and it will ask you the region in which you want to set up the solution or you can type "All" to set it up in all aws regions.

```bash
bash script.sh
```

## Screenshots:


![Alt text](./screenshots/t1.png?raw=true "Terraform and Ansible in action")
