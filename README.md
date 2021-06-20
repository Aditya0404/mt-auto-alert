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
  *  The Backend path mentioned as of now is "/Users/Aditya/state/folder/terraform.tfstate", you have to change it to the location you want to save the state file to. Please follow the format:
  "\<your-location\>/folder/terraform.tfstate"

Step 3. In the file sns.tf, add the email addresses of the respective owners in the variable "sns_subs" and also add the corresponding owner names in variable "sns_names". For example, if I add "myemailaddress@gmail.com" in sns_subs and "amunjal" in sns_names, then to set the target of auto alert, I will tag my instances as "owner:amunjal".

Step 4. (optional) If You have already enabled Cloudtrail in your account, you can either comment everything in cloudtrail.tf file for delete it.

Step 5. Just run the bash script: script.sh and it will ask you the region in which you want to set up the solution or you can type "All" to set it up in all aws regions.

```bash
bash script.sh
```

## Screenshots(Script in action):

1. First, it will ask you the region in which you want to deploy this solution:

![Alt text](./screenshots/1.png?raw=true "Terraform in action")

2. Then you can see the output, terraform will create 14 resources for you.

![Alt text](./screenshots/2.png?raw=true "Terraform in action")

3. After this, you can test the solution by just launching an EC2 instance with the tags: threshold and owner(will be same as of sns topic name)

![Alt text](./screenshots/3.png?raw=true "Terraform in action")


![Alt text](./screenshots/4.png?raw=true "Terraform in action")

4. After EC2 starts running, head over to the cloudwatch console and see that an alarm will be automatically created with threshold mentioned in the tag value:

![Alt text](./screenshots/5.png?raw=true "Terraform in action")

5. And in action of this alarm, the same sns will be mentioned. This solution creates an SNS topic by the name amunjal, you can change this in SNS.tf

![Alt text](./screenshots/6.png?raw=true "Terraform in action")
