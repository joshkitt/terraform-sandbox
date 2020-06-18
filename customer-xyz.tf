locals {
  customer_xyz = {
    stageAccounts = [
      "<arn:root>"
    ]
    prodAccounts = [
      "<arn:root>"
    ]
    topics = [
      local.topics.topic2
    ]
  }
}
