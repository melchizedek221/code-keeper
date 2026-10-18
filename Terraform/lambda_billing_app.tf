resource "aws_lambda_function" "billing_lambda" {
  filename      = "../lambda_function.zip"
  function_name = "billing-processor"
  role         = aws_iam_role.lambda_role.arn
  handler      = "main.lambda_handler"
  runtime      = "python3.9"
  timeout      = 30
  memory_size  = 128

  environment {
    variables = {
    DATABASE_URL = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.rds-db.endpoint}/billing_db"
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_group_ids = aws_db_instance.rds-db.vpc_security_group_ids
  }
}


# IAM Role pour la Lambda
resource "aws_iam_role" "lambda_role" {
  name = "billing_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy pour permettre à la Lambda d'accéder à SQS et aux logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "billing_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [aws_sqs_queue.billing_queue.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = ["*"]
      }
    ]
  })
}