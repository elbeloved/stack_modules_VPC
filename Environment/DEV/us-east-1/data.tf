locals{
  db_cred = jsondecode(
    data.aws_secretsmanager_secret_version.credentials.secret_string
  )
}

data "aws_ami" "stack_ami" {
  owners      = ["self"]
  name_regex  = "^ami-stack*"
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-stack-5*"]
  }
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = "cred"
}

