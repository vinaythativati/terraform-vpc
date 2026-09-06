output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet" {
    value = aws_subnet.public[*].id
}

output "backend_subnet" {
    value = aws_subnet.backend[*].id
}

output "database_subnet" {
    value = aws_subnet.database[*].id
}