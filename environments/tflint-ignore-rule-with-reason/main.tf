resource "aws_instance" "foo" {
  ami = "ami-0ff8a91507f77f867"
  # tflint-ignore: aws_instance_invalid_type, aws_instance_previous_type
  instance_type = "t1.2xlarge"
}

# tflint-ignore: terraform_unused_declarations # v0.49.0からはコメントとしてみなされる
data "aws_s3_bucket" "v0_49" {
  bucket = "my_bucket"
}

# v0.48.0ではtflint-ignore行にコメントを含めることはできない
# tflint-ignore: terraform_unused_declarations
data "aws_s3_bucket" "v0_48" {
  bucket = "my_bucket"
}

# tflint-ignore: terraform_unused_declarations v0.47.0まではコメントとしてみなされる
data "aws_s3_bucket" "v0_47" {
  bucket = "my_bucket"
}
