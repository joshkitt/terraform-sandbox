locals {
  customer_abc = {
    stageAccounts = [
      "<arn:root>"
    ]
    prodAccounts = [
      "<arn:root>"
    ]
    topics = [
      local.topics.topic1,
      local.topics.topic2
    ]
  }
}
