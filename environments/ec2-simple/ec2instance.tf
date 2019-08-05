resource "aws_instance" "web" {
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public.id

  tags = {
    Name = "TerraformSimpleScript"
  }
}
