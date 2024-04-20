# data "template_file" "bootstrap" {
#   template = file(format("%s/scripts/bootstrap.tpl", path.module))
#   vars={
#     GIT_REPO    = "https://github.com/stackitgit/CliXX_Retail_Repository.git"
#     MOUNT_POINT = "/var/www/html"
#     WP_CONFIG   = "/var/www/html/wp-config.php"
#     DB_HOST_NEW = module.RDS-BASE[0].endpoint
#     LB_DNS      = module.ASG-BASE[0].dns_name
#     DB_USER     = local.db_cred.DB_USER
#     DB_PASSWORD = local.db_cred.DB_PASSWORD
#     EFS_DNS     = module.EFS-BASE[0].dns_name
#   } 
# }

data "template_file" "ECSbootstrap" {
  template = file(format("%s/scripts/ECSbootstrap.tpl", path.module))
  vars={
    CLUSTER     = module.ECS-BASE[0].ecs_cluster
  }
}