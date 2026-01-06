output "vpc_id" { value = aws_vpc.vpc.id }

output "public_subnet_1_id" { 
    value = aws_subnet.public_az1.id 
}
output "public_subnet_2_id" { 
    value = aws_subnet.public_az2.id 
}

output "private_subnet_az1_1_id" { 
    value = aws_subnet.private_az1_1.id 
}
output "private_subnet_az1_2_id" { 
    value = aws_subnet.private_az1_2.id 
}
output "private_subnet_az2_1_id" { 
    value = aws_subnet.private_az2_1.id 
}
output "private_subnet_az2_2_id" { 
    value = aws_subnet.private_az2_2.id 
}
