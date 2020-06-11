{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "default",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:SetTopicAttributes",
        "SNS:RemovePermission",
        "SNS:Receive",
        "SNS:Publish",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:AddPermission"
      ],
      "Resource": "${resource}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${sourceOwner}"
        }
      }
    },
    {
      "Sid": "client_account_subscribers",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
        %{ for s in subscribers ~}
        %{ for a in s.accounts ~}
        ${a}
        %{ endfor ~}
        %{ endfor ~}
        ]
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:Receive"
      ],
      "Resource": "${resource}"
    }
  ]
}
