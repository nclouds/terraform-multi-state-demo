output "ami_id" {
  value = "${data.aws_ami.ubuntu.id}"
}

output "site_url" {
  value = "http://${aws_instance.web.public_ip}/index.html"
}
