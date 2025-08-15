terraform {
  backend "gcs" {
    bucket = "tf-bucket-xyz12"
    prefix = "tta/main"
  }
}
