# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   # Configuration des attributs utilisateur
#   schema {
#     attribute_data_type = "String"
#     name                = "email"
#     required            = true
#     mutable             = true
#   }

#   # Politique de mot de passe
#   password_policy {
#     minimum_length                   = 8
#     require_lowercase                = true
#     require_numbers                  = true
#     require_symbols                  = true
#     require_uppercase                = true
#     temporary_password_validity_days = 7
#   }

#   # Configuration des paramètres avancés
#   auto_verified_attributes = ["email"]
# }

# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name = "my-user-pool-client"

#   user_pool_id = aws_cognito_user_pool.my_user_pool.id

#   # Configuration du client
#   explicit_auth_flows = [
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_USER_SRP_AUTH"
#   ]

#   generate_secret = false # Ne pas générer de secret pour les applications mobiles ou web
# }

# resource "aws_cognito_identity_pool" "my_identity_pool" {
#   identity_pool_name               = "my-identity-pool"
#   allow_unauthenticated_identities = false

#   cognito_identity_providers {
#     client_id     = aws_cognito_user_pool_client.my_user_pool_client.id
#     provider_name = aws_cognito_user_pool.my_user_pool.endpoint
#   }
# }

# resource "aws_iam_role" "authenticated_role" {
#   name = "cognito-authenticated-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Principal = {
#           Federated = "cognito-identity.amazonaws.com"
#         }
#         Condition = {
#           StringEquals = {
#             "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.my_identity_pool.id
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_cognito_identity_pool_roles_attachment" "roles_attachment" {
#   identity_pool_id = aws_cognito_identity_pool.my_identity_pool.id

#   roles = {
#     "authenticated" = aws_iam_role.authenticated_role.arn
#   }
# }

# resource "aws_cognito_user_pool_domain" "my_domain" {
#   domain       = "my-auth-domain"
#   user_pool_id = aws_cognito_user_pool.my_user_pool.id
# }

# resource "aws_cognito_identity_provider" "google" {
#   user_pool_id  = aws_cognito_user_pool.my_user_pool.id
#   provider_name = "Google"
#   provider_type = "Google"

#   provider_details = {
#     client_id        = "votre-client-id-google"
#     client_secret    = "votre-client-secret-google"
#     authorize_scopes = "email profile openid"
#   }

#   attribute_mapping = {
#     email    = "email"
#     username = "sub"
#   }
# }