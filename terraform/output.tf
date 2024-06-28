# Show the hostname of workstation.
output "workstation_hostnames" {
  description = "Workstation dns name"
  value       = aws_route53_record.workstation.fqdn
}

# Show the hostname of servers.
output "server_hostnames" {
  description = "Server dns name"
  value       = aws_route53_record.server.*.fqdn
}
