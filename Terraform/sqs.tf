resource "aws_sqs_queue" "billing_queue" {
  name                      = "billing-queue"
  delay_seconds             = 0
  max_message_size         = 262144  # 256 KB
  message_retention_seconds = 86400   # 1 jour
  receive_wait_time_seconds = 10      # Long polling
  visibility_timeout_seconds = 30     # Temps de traitement max pour un message
  
  tags = {
    Environment = "production"
    Managed_by  = "terraform"
  }
}
