provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::152204665473:role/cp-aws-sandbox-power-user-role"
  }
}
