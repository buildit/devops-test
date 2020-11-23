module "instance_template" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "5.1.0"

  project_id         = var.gcp_project
  network            = var.vpc

  machine_type      = var.machine_type
  preemptible       = var.preemptible
  disk_size_gb      = var.disk_size_gb

  source_image_project = "debian-cloud"
  source_image_family  = "debian-10"

  metadata = {
    startup-script = file("userdata.sh")
  }

  access_config = [
    {
      nat_ip = "" # Auto-assigned NAT IP
      network_tier = "STANDARD"
    }
  ]

  tags = [
    "wipro-test"
  ]

  service_account = {
    email  = ""
    scopes = ["logging-write"]
  }
}

module "managed_instance_group" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  version           = "5.1.0"

  project_id        = var.gcp_project
  region            = var.gcp_region

  target_size       = var.instances
  hostname          = var.hostname_prefix
  instance_template = module.instance_template.self_link

  named_ports       = [
    {
      name = "http"
      port = 3000
    }
  ]
}
