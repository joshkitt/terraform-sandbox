variable "testing" {
  default = []
}

variable "subscribers" {
  type = list(object({
    name = string
    accounts = list(string)
    topics = list(string)
  }))
  default = [
    {
      name = "subscriber1"
      accounts = [
      ]
      topics = [
        "Sandbox-Topic"
      ]
    },
    {
      name = "subscriber2"
      accounts = [
      ]
      topics = [
        "Sandbox-Topic"
      ]
    }
  ]
}

locals {
  test = var.subscribers
  a = flatten([
  for s in var.subscribers : [
  for a in s.accounts : [
    a
  ]
  ]
  ])
}

output "test" {
  value = local.a
}

resource "aws_sns_topic" "this" {
  name = "Sandbox-Topic1"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"
  statement {
    sid = "__default_statement_ID"
    effect = "Allow"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }
    condition {
      test = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
    resources = [
      aws_sns_topic.this.arn
    ]
  }
  statement {
    sid = "client_account_subscribers"
    effect = "Allow"
    actions = [
      "SNS:Subscribe",
      "SNS:Receive"
    ]
    principals {
      type = "AWS"
      identifiers = flatten([
      for s in var.subscribers : [
      for a in s.accounts : [
        a
      ]
      ]
      ])
    }
    resources = [
      aws_sns_topic.this.arn
    ]
  }
}
