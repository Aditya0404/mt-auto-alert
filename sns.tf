#DevOps Engineer Name: Aditya Munjal
#Owner: amunjal
#Owner tag on ec2 will be same as the SNS Topic name

resource "aws_sns_topic" "alert-list" {
  name = "amunjal"
}

resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn = aws_sns_topic.alert-list.arn
  protocol  = "email"
  endpoint  = "aditya.munjal73@gmail.com"
}
