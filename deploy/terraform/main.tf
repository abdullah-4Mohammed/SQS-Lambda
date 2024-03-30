# add resource lambda function python ToBeInvoked
resource "aws_lambda_function" "SQS-lam" {
  function_name = "${local.resourceName}-SQS-lam"
  handler = "SQS-lam.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.lamb_sync_async_role.arn
  filename = "${path.module}/../../src/lambda/invoked-lam.zip"
}

# resource "aws_lambda_function" "Invoker" {
#   function_name = "${local.resourceName}-InvokerLambda"
#   handler       = "invoker-lam.lambda_handler"
#   runtime       = "python3.8"
#   role          = aws_iam_role.lamb_sync_async_role.arn
#   filename      = "${path.module}/../../src/lambda/invoker-lam.zip"
#   environment {
#     variables = {
#       INVOKED_LAMBDA_ARN = aws_lambda_function.ToBeInvoked.arn
#     }
#   }
# }


# Create the IAM role
resource "aws_iam_role" "lamb_sync_async_role" {
  name = "${local.resourceName}-lamb_sync_async_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach the necessary permissions to the role
resource "aws_iam_role_policy" "lamb_sync_async_role" {
  name = "${local.resourceName}-lamb_sync_async_role_policy"
  role = aws_iam_role.lamb_sync_async_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction",
        "lambda:InvokeAsync"
      ],
      "Resource": "arn:aws:lambda:*:*:function:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}


