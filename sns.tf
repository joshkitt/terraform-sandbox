resource "aws_sns_topic" "this" {
  for_each = local.topics
  name = "${each.value}-${var.ENV}"
  sqs_success_feedback_sample_rate = 10
  policy = templatefile("sns-policy.json.tpl", {
    resource = "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:${each.value}-${var.ENV}"
    sourceOwner = data.aws_caller_identity.current.account_id
    subscribers = jsonencode(distinct(flatten([
      ("arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"),
      [for c in local.customers : [
        (var.ENV == "stage" && contains(c.topics, each.value) ? c.stageAccounts : []),
        (var.ENV == "prod" && contains(c.topics, each.value) ? c.prodAccounts : [])
      ]]
    ])))
  })
}
