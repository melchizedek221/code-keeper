# resource "aws_kms_key" "rds_kms_key" {
#   description             = "KMS key for RDS encryption"
#   deletion_window_in_days = 10 # Durée avant suppression définitive de la clé
#   enable_key_rotation     = true # Activation de la rotation automatique des clés
# }

# resource "aws_kms_alias" "rds_kms_alias" {
#   name          = "alias/rds-kms-key"
#   target_key_id = aws_kms_key.rds_kms_key.key_id
# }