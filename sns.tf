# DevOps Engineer Name: Aditya Munjal
# Owner: amunjal
# Owner tag on ec2 will be same as the SNS Topic name
# You can add more SNS topic and subscription resources here and they will be created in every region

variable "sns_names" {
  description = "Create sns topics"
  type        = list(string)
  default     = ["amunjal", "kmunjal"]
}


variable "sns_subs" {
  description = "Create sns topics"
  type        = list(string)
  default     = ["adityamunjal73@gmail.com", "komalmunjal1203@gmail.com"]
}

resource "aws_sns_topic" "alert-list" {
  count = length(var.sns_names)
  name = var.sns_names[count.index]
}

resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn = aws_sns_topic.alert-list[count.index].arn
  count = length(var.sns_subs)
  protocol  = "email"
  endpoint  = var.sns_subs[count.index]
}
