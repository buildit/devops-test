locals {
  network_tags = [
    "wipro-test-${var.name}"
  ]
}

module "lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "4.4.0"

  name              = "wipro-${var.name}-lb"
  project           = var.gcp_project
  target_tags       = local.network_tags
  firewall_networks = [var.vpc]

  backends = {
    wipro-test = {
      protocol                        = "HTTP"
      port                            = 3000
      port_name                       = "http"
      description                     = "Load balancer backend for the wipro devops test service"

      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null

      health_check = {
        host                = null
        request_path        = "/"
        port                = 3000

        check_interval_sec  = 5
        timeout_sec         = 1
        healthy_threshold   = 1
        unhealthy_threshold = 3

        logging             = true
      }

      log_config = {
        enable      = true
        sample_rate = null
      }

      groups = [
        {
          group                        = module.managed_instance_group.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}
