resource "null_resource" "kubeconfig" {
  depends_on = [aws_eks_cluster.eks]

  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.eks.name}"
  }
}