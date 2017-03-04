data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    subnet_id = "${data.terraform_remote_state.network.public_subnets[0]}"
    key_name = "${var.ssh_key}"
    vpc_security_group_ids = [ "${data.terraform_remote_state.security.web_sgs}" ]
    tags {
        Name = "Terraform Chef Demo - Apache2"
    }
    connection {
      type = "ssh"
      user = "ubuntu"
      agent = true
    }
    provisioner "remote-exec" {
        inline = [
        "sudo apt-get update",
        "sudo apt-get install apache2"
        "sudo systemctl restart apache2"
        ]
    }
}
