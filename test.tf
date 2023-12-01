provider "aws" {
  region = "your_region"
}

resource "aws_iam_role" "opensearch_role" {
  name = "opensearch_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_opensearch_domain" "example" {
  domain_name           = "example-domain"
  elasticsearch_version = "7.10"
  node_to_node_encryption_options {
    enabled = false
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}

resource "aws_opensearch_domain_access_policy" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  access_policies = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "es:ESHttp*",
      "Resource": "arn:aws:es:your_region:your_account_id:domain/example-domain/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "your_ip_address"
        }
      }
    }
  ]
}
EOF
}

resource "aws_opensearch_domain_policy" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  access_policies = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:your_region:your_account_id:domain/example-domain/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "your_ip_address"
        }
      }
    }
  ]
}
EOF
}

resource "aws_opensearch_domain_auth" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  master_user_name = "admin"
  master_user_password = "your_password"
  enabled = true
}

resource "aws_opensearch_domain_vpc_options" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  vpc_id      = "your_vpc_id"
  subnet_ids  = ["your_subnet_id"]
}

resource "aws_opensearch_domain_node_to_node_encryption_options" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  enabled     = false
}

resource "aws_opensearch_domain_snapshot_options" "example" {
  domain_name     = aws_opensearch_domain.example.domain_name
  automated_snapshot_start_hour = 0
}

resource "aws_opensearch_domain_cognito_options" "example" {
  domain_name = aws_opensearch_domain.example.domain_name
  enabled     = false
}
