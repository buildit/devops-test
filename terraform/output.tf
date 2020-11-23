output "instance_group_" {
  value = module.managed_instance_group.instance_group
}

output "instance_group_manager" {
  value = module.managed_instance_group.instance_group_manager
}


output "backend_services" {
  description = "The backend service resources."
  value       = module.lb-http.backend_services
}

output "external_ip" {
  description = "The external IP assigned to the global fowarding rule."
  value       = module.lb-http.external_ip
}
