data "aws_s3_bucket_objects" "bucket_objects" {
  bucket = "your-bucket-name"
}



locals {
  expected_md5_hash = {
    "file1.txt" = "expected_md5_for_file1",
    "file2.txt" = "expected_md5_for_file2",
    # Add more file entries as needed
  }
}

resource "null_resource" "corrupted_file_check" {
  count = length(data.aws_s3_bucket_objects.bucket_objects.objects)

  triggers = {
    object_key = data.aws_s3_bucket_objects.bucket_objects.objects[count.index].key
  }

  provisioner "local-exec" {
    command = <<EOF
      # Calculate MD5 hash of the object and compare it with expected MD5 hash
      actual_md5=$(aws s3api head-object --bucket your-bucket-name --key ${self.triggers.object_key} --query 'ETag' --output text)
      expected_md5=${local.expected_md5_hash[self.triggers.object_key]}

      if [ "$actual_md5" == "$expected_md5" ]; then
        echo "File ${self.triggers.object_key} is not corrupted."
      else
        echo "File ${self.triggers.object_key} might be corrupted."
      fi
    EOF
  }
}
