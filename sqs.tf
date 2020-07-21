resource aws_sqs_queue "this" {
  name = "default-${var.ENV}"
  kms_master_key_id = aws_kms_key.this.key_id
  kms_data_key_reuse_period_seconds = 86400
}

data "aws_iam_policy_document" "default_subscription_policy" {
  policy_id = "__default_policy_ID"
  statement {
    sid = "__owner_statement"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
  statement {
    sid = "subscribers"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }
    actions = [
      "SQS:SendMessage"
    ]
    resources = [
      aws_sqs_queue.this.arn
    ]
    condition {
      test = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        var.SNS_ARN
      ]
    }
  }
}

# policy for sns topics to send messages to sqs queue
resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id
  policy = data.aws_iam_policy_document.default_subscription_policy.json
}
