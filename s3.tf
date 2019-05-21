resource "aws_s3_bucket" "bucket_prod" {
    bucket = "sample-backet"
    acl = "private"
}
