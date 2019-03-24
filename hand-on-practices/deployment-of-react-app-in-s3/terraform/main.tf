provider "aws" {
  region = "eu-west-1"
  profile = "dondanidang"
}

resource "aws_s3_bucket" "admin_bucket" {
  bucket = "${var.bucket_name}"

  acl = "public-read"

  website {
    index_document = "${var.entry_file}"
    error_document = "${var.error_file}"
  }
}

resource "aws_s3_bucket_public_access_block" "admin_bucket" {
  bucket = "${aws_s3_bucket.admin_bucket.id}"
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "admin_bucket" {
  bucket = "${aws_s3_bucket.admin_bucket.id}"

  policy = "${data.aws_iam_policy_document.admin_bucket.json}"
}

data "aws_iam_policy_document" "admin_bucket" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.admin_bucket.arn}/*"
    ]

    effect = "Allow"

    principals {
      type = "*"

      identifiers = ["*"]
    }

    condition {
      test = "IpAddress"
      variable = "aws:SourceIp"
      values = [
        "95.19.248.7",
        "91.187.71.47"
      ]
    }
  }
}
