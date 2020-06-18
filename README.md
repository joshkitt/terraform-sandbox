# Terraform Sandbox

Sandbox for trying out different things in Terraform.

Use a for loop to iterate subscribers for an SNS Topic to dynamically create an 
SNS Topic access policy which grants SNS:Subscribe and SNS:Receive using a 
templatefile function and variables

```shell script
tf init
tf plan -var 'ENV=dev'
tf apply -var 'ENV=dev'
tf destroy -var 'ENV=dev'
```
