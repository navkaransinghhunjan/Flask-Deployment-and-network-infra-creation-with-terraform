output "instance_public_ip" {
  value       = aws_instance.server.public_ip
  description = "Public IP address of the EC2 instance"
}

output "flask_app_url" {
  value       = "http://${aws_instance.server.public_ip}"
  description = "URL to access the Flask application"
} 