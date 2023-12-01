provider "aws" {
  region = "your_aws_region"
}

resource "aws_opensearch_domain" "example" {
  domain_name           = "your-opensearch-domain-name"
  elasticsearch_version = "7.10"

  node_to_node_encryption_options {
    enabled = true
  }

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }
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
        "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:root"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:your-region:your-account-id:domain/your-opensearch-domain-name/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "example" {
  name = "your-iam-role-name"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonESFullAccess"
  role       = aws_iam_role.example.name
}

resource "aws_opensearch_domain_access_policies" "example" {
  domain_name   = aws_opensearch_domain.example.domain_name
  access_policies = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:role/your-iam-role-name"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:your-region:your-account-id:domain/your-opensearch-domain-name/*"
    }
  ]
}
EOF
}
