terraform {
  backend "gcs" {
    bucket = var.bucket_name
    prefix = "tta/database"
  }
}
