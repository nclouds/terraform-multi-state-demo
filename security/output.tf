output "web_sgs" {
  value = ["${aws_security_group.allow_ssh_http.id}"]
}
