# Define the IAM Policy
resource "aws_iam_policy" "eks_policy" {
  name        = "gdl-eks-policy"
  description = "EKS Policy for creating node groups and related permissions"
  policy      = jsonencode({
    Version = "2012-10-17"
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:ListKeys",
          "kms:TagResource",
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:ListAliases",
          "kms:PutKeyPolicy"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:TagResource",
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource",
          "logs:PutLogEvents",
          "logs:DeleteLogGroup",
          "logs:CreateLogStream",
          "logs:PutRetentionPolicy"
        ],
        "Resource": "*"
      }
	  ]
  })
  tags = {
    Environment = "development"
    Application = "eks-cluster"
    CreatedBy  = "Gautam Limbani"
    PolicyAttachment = "eks-policy-attachment"
  }
}

# Fetch the IAM user to whom the policy will be attached
resource "aws_iam_user" "eks_user" {
  name = "gautam.limbani"
}

# Attach the policy to the IAM user
resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  name       = "eks-policy-attachment"
  users      = [aws_iam_user.eks_user.name]
  policy_arn = aws_iam_policy.eks_policy.arn
}