resource "google_project_service" "this" {
  for_each           = toset(var.services)
  service            = "${each.key}.googelapis.com"
  disable_on_destroy = false
}
