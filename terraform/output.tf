output "external_url" {
  description = "The full URL for reaching the load balancer."
  value       = "http://${module.lb-http.external_ip}/"
}
