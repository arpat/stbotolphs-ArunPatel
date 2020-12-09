resource "aws_s3_bucket" "bucket" {
  bucket = "stbotolphs-ude3qzzeda"
  tags   = {}

  grant {
    permissions = [
      "READ",
      "READ_ACP",
    ]
    type = "Group"
    uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
  }
  grant {
    id = "0ac4f47944fd2e722f2de9303ecc3e7a6e2aa3f6cda2fd5e58e42b75d4dd70b7"
    permissions = [
      "READ",
      "READ_ACP",
      "WRITE",
      "WRITE_ACP",
    ]
    type = "CanonicalUser"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}
