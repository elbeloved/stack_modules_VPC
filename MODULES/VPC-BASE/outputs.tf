output "stack_vpc_id" {
    value = aws_vpc.stack.id
}

output "private_subnet" {
    value = "${aws_subnet.private_stack[*].id}"
}

output "private_subnet_1b" {
    value = "${aws_subnet.private_stack_1b[*].id}"
}

output "public_subnet" {
    value = "${aws_subnet.public_stack[*].id}"
}

output "public_subnet_1b" {
    value = "${aws_subnet.public_stack_1b[*].id}"
}
