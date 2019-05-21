variable "aws_db_username" {}
variable "aws_db_password" {}
variable "key_name" {}

variable web_servers_count {
    default = 1
}


provider "aws" {
  profile = "sampleprofile"
  region = "ap-northeast-1"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}
