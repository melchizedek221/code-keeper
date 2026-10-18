terraform {
  source = "../../terraform"
  
  # extra_arguments "no_input" {
  #   commands = ["init"]
  #   arguments = ["-input=false"]
  # }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "tf-state-bucket-djibsow"
    key            = "envs/staging/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    skip_credentials_validation = true
    skip_metadata_api_check = true
    # skip_bucket_version_validation = true
  }
}
