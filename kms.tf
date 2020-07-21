# policy document for kms key
# allow sns service to use the key
data "aws_iam_policy_document" "kms_key" {
  policy_id = "__default_policy_ID"
  statement {
    sid = "default"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "sns"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com"
      ]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }
}

# kms key
resource "aws_kms_key" "this" {
  description = "Key for ${var.ENV}"
  deletion_window_in_days = 14
  policy = data.aws_iam_policy_document.kms_key.json
}

# alias for kms key
resource "aws_kms_alias" "this" {
  name = "alias/key-${var.ENV}"
  target_key_id = aws_kms_key.this.key_id
}
