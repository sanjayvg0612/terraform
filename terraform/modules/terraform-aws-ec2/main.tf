resource "aws_instance" "ems" {
  
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.aws_subnet[0]
  vpc_security_group_ids = ["$aws_default_security_group.sg.id"]

  

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
resource "aws_instance" "ems1" {

  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  associate_public_ip_address = false
  subnet_id = var.aws_subnet[1]
  vpc_security_group_ids = ["$(aws_default_security_group.sg.id)"]
  
 
  

  tags = {
    Name = "ExampleAppServerInstance2"
  }
}

