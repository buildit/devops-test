module "instance_template" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "5.1.0"

  project_id         = var.gcp_project
  network            = var.vpc

  service_account = {
    email  = ""
    scopes = []
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
}
