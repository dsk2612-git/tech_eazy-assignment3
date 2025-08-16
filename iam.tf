##############################
# IAM Role 1: Read-only on S3
##############################
resource "aws_iam_role" "s3_readonly_role" {
  name = "s3-readonly-role-${trimspace(var.stage)}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name = "s3-readonly-policy-${trimspace(var.stage)}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:ListBucket"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.s3_readonly_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

resource "aws_iam_instance_profile" "readonly_instance_profile" {
  name = "readonly-instance-profile-${trimspace(var.stage)}"
  role = aws_iam_role.s3_readonly_role.name
}

##############################
# IAM Role 2: Full access for logs
##############################
resource "aws_iam_role" "s3_fullaccess_role" {
  name = "s3-fullaccess-role-${trimspace(var.stage)}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_fullaccess_policy" {
  name = "s3-fullaccess-policy-${trimspace(var.stage)}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fullaccess_attach" {
  role       = aws_iam_role.s3_fullaccess_role.name
  policy_arn = aws_iam_policy.s3_fullaccess_policy.arn
}
