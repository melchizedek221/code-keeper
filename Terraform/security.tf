# resource "aws_wafv2_web_acl" "web_acl" {
#   name        = "MyWebACL"
#   scope       = "REGIONAL"
  
#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "AWSManagedRulesCommonRuleSet"
#     priority = 1

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "webACL"
#       sampled_requests_enabled   = true
#     }

#     override_action {
#       none {}
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "myWebAclMetric"
#     sampled_requests_enabled   = true
#   }
# }
