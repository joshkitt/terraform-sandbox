variable "testing" {
  default = []
}

variable "subscribers" {
  type = list(object({
    name = string
    topics = list(string)
    accounts = list(string)
    topics = list(string)
  }))
  default = [
    {
      name = "subscriber1"
      accounts = [
        "166445975460", "1234"
      ]
      topics = [
        "Sandbox-Topic", "Another Topic"
      ]
    },
    {
      name = "subscriber2"
      accounts = [
        "838401776392", "5678"
      ]
      topics = [
        "Sandbox-Topic2"
      ]
    },
    {
      name = "subscriber3"
      accounts = [
        "166445975460", "9012"
      ]
      topics = [
        "Sandbox-Topic", "Another Topic"
      ]
    },
  ]
}

locals {
  test = var.subscribers
  a = distinct(flatten([
    for s in var.subscribers : [
      for a in s.topics : s.accounts if a == "Another Topic"
//      contains(s.topics, "Another Topic") ? s.accounts : ""
    ]
  ]))
}

//locals {
//  test = var.subscribers
//  a = flatten([
//  for s in var.subscribers : [
//  for a in s.topics : s.accounts if a == "Another Topic"
//  //      contains(s.topics, "Another Topic") ? s.accounts : ""
//  ]
//  ])
//}

output "test" {
  value = local.a
}

resource "aws_sns_topic" "this" {
  name = "Sandbox-MyNewTopic"
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
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
      identifiers = distinct(flatten([
        for s in var.subscribers : [
//          for a in s.topics : s.accounts if a == "Another Topic"
            contains(s.topics, "Another Topic") ? s.accounts : []
        ]
      ]))
    }
    resources = [
      aws_sns_topic.this.arn
    ]
  }
}
