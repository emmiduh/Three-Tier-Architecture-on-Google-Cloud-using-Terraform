terraform {
  backend "gcs" {
    bucket = "tf-bucket-xyz"
    prefix = "tta/foundation"
  }
}
