resource "aws_sns_topic" "alert-list" {
  name = "kmunjal"
}

resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn = aws_sns_topic.alert-list.arn
  protocol  = "email"
  endpoint  = "aditya.munjal73@gmail.com"
}
