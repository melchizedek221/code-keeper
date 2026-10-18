#!/bin/bash

# Scan du cluster avec Trivy
trivy k8s --report summary cluster

# Scan de conformité avec kube-bench
kube-bench --eks

# Journalisation des résultats
echo "Scan terminé à $(date)" >> /var/log/eks_scans.log
