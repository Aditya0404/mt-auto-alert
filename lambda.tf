resource "aws_lambda_function" "auto_alert" {
    filename = "abc.zip"
    function_name = "auto_alert"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "lambda2.lambda_handler"
 runtime          = "python3.7"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "ec2:DescribeInstances"
            ],
            "Resource": "*"
        },
	{
            "Sid": "VisualEditor1",
	    "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
	    "Sid":  "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.auto_alert.function_name}:*"
            ]
        }

    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}



resource "aws_cloudwatch_event_rule" "auto_alert_rule" {
name        = "auto_alert_rule"
description = "Capture each AWS Console Sign In"

event_pattern = <<EOF
{
"source": [
  "aws.ec2"
],
"detail-type": [
  "AWS API Call via CloudTrail"
],
"detail": {
  "eventSource": [
    "ec2.amazonaws.com"
  ],
  "eventName": [
    "RunInstances"
  ]
}
}
EOF
}

resource "aws_cloudwatch_event_target" "auto_alert_auto_alert_rule" {
    rule = "${aws_cloudwatch_event_rule.auto_alert_rule.name}"
    target_id = "auto_alert"
    arn = "${aws_lambda_function.auto_alert.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_auto_alert" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.auto_alert.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.auto_alert_rule.arn}"
}
