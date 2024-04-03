resource "aws_db_instance" "stack" {
    snapshot_identifier    = data.aws_db_snapshot.stack.id
    instance_class         = var.instance_class
    skip_final_snapshot    = var.skip_final_snapshot
    db_subnet_group_name   = aws_db_subnet_group.db_stances.name
    vpc_security_group_ids = var.security_group_priv
    tags                   = merge({Name  = "${var.project}-dbname", }, var.required_tags)
}

data "aws_db_snapshot" "stack" {
    db_snapshot_identifier = var.snapshot_identifier
    most_recent            = var.most_recent
}

resource "aws_db_subnet_group" "db_stances" {
    name                   = "stack_databases"
    subnet_ids             = flatten(["${var.private_subnet}", "${var.private_subnet_1b}"])
}
