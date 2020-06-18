resource "aws_sns_topic" "topic1" {
  name = "${local.topics.topic1}-${var.ENV}"
}

resource "aws_sns_topic_policy" "policy1" {
  count = (var.ENV == "stage" || var.ENV == "prod") ? 1 : 0
  arn = aws_sns_topic.topic1.arn
  policy = templatefile("sns-policy.json.tpl", {
    resource = aws_sns_topic.topic1.arn
    sourceOwner = data.aws_caller_identity.current.account_id
    subscribers = jsonencode(distinct(flatten([
      ("arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"),
      [for c in local.customers : [
        (var.ENV == "stage" && contains(c.topics, local.topics.topic1) ? c.stageAccounts : []),
        (var.ENV == "prod" && contains(c.topics, local.topics.topic1) ? c.prodAccounts : [])
      ]]
    ])))
  })
}

resource "aws_sns_topic" "topic2" {
  name = "${local.topics.topic2}-${var.ENV}"
}

resource "aws_sns_topic_policy" "policy2" {
  count = (var.ENV == "stage" || var.ENV == "prod") ? 1 : 0
  arn = aws_sns_topic.topic2.arn
  policy = templatefile("sns-policy.json.tpl", {
    resource = aws_sns_topic.topic2.arn
    sourceOwner = data.aws_caller_identity.current.account_id
    subscribers = jsonencode(distinct(flatten([
      ("arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"),
      [for c in local.customers : [
        (var.ENV == "stage" && contains(c.topics, local.topics.topic2) ? c.stageAccounts : []),
        (var.ENV == "prod" && contains(c.topics, local.topics.topic2) ? c.prodAccounts : [])
      ]]
    ])))
  })
}

