# Microservices DevOps Pipeline Project

This project demonstrates a complete DevOps pipeline for a microservices-based application, following industry best practices for CI/CD, security, and infrastructure automation. It covers everything from source control to automated deployment on cloud infrastructure, using tools like GitLab, Ansible, Terraform, Docker, and Kubernetes.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Pipeline Design](#pipeline-design)
- [Security Practices](#security-practices)
- [Prerequisites](#prerequisites)
- [Setup & Usage](#setup--usage)
- [Repository Structure](#repository-structure)
- [Role Play & Audit](#role-play--audit)
- [Bonus Features](#bonus-features)
- [Contributing](#contributing)
- [License](#license)

---

## Project Overview

You will find a robust, production-grade pipeline for deploying and managing a microservices application. The pipeline automates infrastructure provisioning, application build/test/scan, containerization, and deployment to both staging and production environments, with strong security controls and manual approvals for production releases.

---

## Architecture

- **Microservices**: Inventory, Billing, API Gateway (each in its own repo)
- **Infrastructure**: AWS (or other cloud), provisioned via Terraform
- **CI/CD**: GitLab CI/CD with self-hosted runners (deployed via Ansible)
- **Containerization**: Docker, deployed to Kubernetes (EKS)
- **Messaging**: RabbitMQ for async communication
- **Databases**: PostgreSQL (AWS RDS)
- **Monitoring**: AWS CloudWatch, VPC Flow Logs

---

## Pipeline Design

### Infrastructure Pipeline (Terraform)

- **Init**: Initialize Terraform working directory and backend
- **Validate**: Check syntax and best practices
- **Plan**: Preview infrastructure changes
- **Apply to Staging**: Provision/update staging environment
- **Approval**: Manual gate before production
- **Apply to Production**: Provision/update production environment

### Application CI Pipeline (per microservice)

- **Build**: Compile/package application
- **Test**: Run unit/integration tests
- **Scan**: Security/code scan (e.g., Snyk, SonarQube)
- **Containerize**: Build & push Docker image to registry

### Application CD Pipeline

- **Deploy to Staging**: Deploy Docker image to staging environment
- **Approval**: Manual gate before production
- **Deploy to Production**: Deploy to production with zero downtime

> **Note:** All pipelines are triggered only on protected branches. Any code change triggers a full pipeline, with manual approval required for production.

---

## Security Practices

- **Protected Branches**: Only allow pipeline triggers from protected branches
- **Secrets Management**: No credentials in code; use environment variables or secret managers
- **Least Privilege**: IAM roles and permissions are tightly scoped
- **Dependency Updates**: Automated and monitored for vulnerabilities
- **Pipeline Security**: Security scans for both code and infrastructure (e.g., tfsec)

---

## Prerequisites

- AWS account (or Azure/GCP)
- Terraform >= 1.0
- Docker
- Python 3.x
- Ansible
- GitLab (self-hosted or SaaS)

---

## Setup & Usage

### 1. Clone the repositories

Each microservice and the infrastructure has its own repository.

```bash
git clone < inventory-repo >
git clone < billing-repo >
git clone < api-gateway-repo >
git clone < infrastructure-repo >
```

### 2. Provision Infrastructure

```bash
cd infrastructure-repo
terraform init
terraform apply
```

### 3. Deploy GitLab & Runners

```bash
cd gitlab-aws-deploy/ansible
ansible-playbook -i hosts.ini install_gitlab.yml
ansible-playbook -i hosts.ini install_runner.yml
```


### 4. Configure CI/CD

- Set up CI/CD variables/secrets in GitLab for each repo (e.g., DB credentials, registry credentials)
- Pipelines will run automatically on push/merge to protected branches

---

## Repository Structure

```
.
├── Terraform/            # Infrastructure as Code
├── Manifests/           # Kubernetes manifests
├── Dockerfiles/         # Docker build files
├── gitlab-aws-deploy/   # GitLab & runner deployment (Ansible)
└── <microservice-repos> # Each service in its own repo
```

---

## Role Play & Audit

Be prepared to present and explain:
- Your pipeline design and security choices
- How you handle secrets and approvals
- How you ensure reliability and zero downtime
- How you would troubleshoot or extend the system

---

## Bonus Features

- Infrastructure security scan with tfsec
- Cost estimation with Infracost
- Multi-environment management with Terragrunt
- Automated dependency updates

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to your branch
5. Open a Pull Request

---

## License

MIT License. See [LICENSE](LICENSE) for details.
