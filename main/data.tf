data "terraform_remote_state" "foundation" {
  backend = "gcs"
  config = {
    bucket = "tf-bucket=xyz"
    prefix = ""
  }
}
