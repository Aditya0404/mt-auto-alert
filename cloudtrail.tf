resource "aws_cloudtrail" "auto-alert" {
  name                          = "tftrail-auto-alert-mindtickle"
  s3_bucket_name                = aws_s3_bucket.mtbucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  depends_on = [
    aws_s3_bucket_policy.mtbucket,
  ]
}

resource "aws_s3_bucket" "mtbucket" {
  bucket        = "${var.aws_region}-tftrail-auto-alert-mindtickle"
  force_destroy = true

}

resource "aws_s3_bucket_policy" "mtbucket" {
  bucket = aws_s3_bucket.mtbucket.id
  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.mtbucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.mtbucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
)
}
