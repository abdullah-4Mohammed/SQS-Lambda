# add resource lambda function python ToBeInvoked
resource "aws_lambda_function" "SQS-lam" {
  function_name = "${local.resourceName}-SQS-lam"
  handler = "SQS-lam.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.sqs-lam-role.arn 
  filename = "${path.module}/../../src/lambda/SQS-lam.zip"
}

//add sqs queue to invoke lambda function
resource "aws_sqs_queue" "SQS" {
  name = "${local.resourceName}-SQS"
}

// add event source mapping sqs-lambda-source-mapping
resource "aws_lambda_event_source_mapping" "sqs-lambda-source-mapping" {
  event_source_arn = aws_sqs_queue.SQS.arn
  function_name = aws_lambda_function.SQS-lam.arn
}


# Create the IAM role
resource "aws_iam_role" "sqs-lam-role" {
  name = "${local.resourceName}-sqs-lam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Create the policy
resource "aws_iam_policy" "sqs-lam-policy" {
  name = "${local.resourceName}-sqs-lam-policy"
  description = "Allow lambda to send logs to CloudWatch"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "sqs-lam-policy-attachment" {
#   role = aws_iam_role.sqs-lam-role.name
#   policy_arn = aws_iam_policy.sqs-lam-policy.arn
# }