resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
    name = "vpc_flow_logs"
    retention_in_days = 7
    tags = {
        Name = "log_group"
    }
}

resource "aws_iam_role" "vpc_flow_logs" {
    name = "vpc-flow-logs-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "vpc-flow-logs.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
    name = "vpc-flow-logs-policy"
    role = aws_iam_role.vpc_flow_logs.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:DescribeLogGroups",
                    "logs:DescribeLogStreams",
                ]
                Effect = "Allow"
                Resource = "*"
            },
        ]
    })
}

resource "aws_flow_log" "vpc_flow_logs" {
    vpc_id = aws_vpc.vpc.id
    log_destination_type = "cloud-watch-logs"
    log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
    traffic_type         = "ALL"
    # max_aggregation_interval = 60
    iam_role_arn = aws_iam_role.vpc_flow_logs.arn

    tags = {
        Name = "vpc-flow-logs"
    }
}

resource "aws_sns_topic" "alerts" {
name = "infrastructure-alerts"

tags = {
    Name = "infrastructure-alerts"
    Purpose = "CloudWatch Alarms"
}
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.alerts.arn]
}


# resource "aws_budgets_budget" "cost_budget" {
#   budget_type = "COST"
#   limit_amount = "500"
#   limit_unit   = "USD"
#   time_unit    = "MONTHLY"

#     # cost_filter {
#     #   values = ["us-east-1"]
#     #   name = "instance-type"
#     # }
# }
