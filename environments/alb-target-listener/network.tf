data "aws_subnet" "public_a" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-1a"]
  }
}

data "aws_subnet" "public_c" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-1c"]
  }
}

data "aws_subnet" "public_d" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-1d"]
  }
}
