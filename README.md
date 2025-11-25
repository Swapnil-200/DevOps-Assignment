# DevOps Assignment – EKS + ArgoCD + NGINX (GitOps)

I have completed a full CI/CD infrastructure setup on AWS using Terraform, EKS, Kubernetes, ArgoCD, and AWS Load Balancer Controller.  
This repository contains the complete infrastructure-as-code, application manifests, and GitOps configuration.

---

## Repository Structure

```
terraform/   -> EKS cluster infrastructure (Terraform code)
manifests/   -> Kubernetes manifests for NGINX deployment
argocd/      -> ArgoCD install & application definition for GitOps
README.md    -> Documentation describing setup, deployment & outcomes
```

---

## Prerequisites

Before running this setup, I configured the following dependencies locally:

- AWS account with required IAM permissions
- Installed CLI tools:
  - awscli
  - kubectl
  - helm
  - terraform (>= 1.6)
  - eksctl
- AWS authentication configured via:
```bash
aws configure
```

---

## 1. Provisioning EKS using Terraform

Inside the `terraform/` directory, I built the infrastructure for:
- VPC
- Internet gateways & subnets
- EKS control plane
- Managed node group
- IAM roles
- kubeconfig output for authentication

### Configure variables (optional)
Edit `terraform/terraform.tfvars.example`:

```hcl
region       = "ap-south-1"
project_name = "demo-eks"
environment  = "dev"
```

### Execute Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Terraform outputs `kubeconfig` credentials:

```bash
terraform output -raw kubeconfig > kubeconfig
export KUBECONFIG=$(pwd)/kubeconfig
kubectl get nodes
```

---

## 2. Deploying NGINX to EKS

All Kubernetes manifests are located inside `manifests/`.

### NGINX Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
```

### NGINX Service (LoadBalancer)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
```

---

## 3. Installing & Configuring ArgoCD

### Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
```

### Expose ArgoCD UI via LoadBalancer
```bash
kubectl apply -f argocd/argocd-server-lb.yaml
kubectl get svc -n argocd
```

Retrieve the initial admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Access UI:
```
https://<ARGOCD-EXTERNAL-IP>
```

---

## 4. Deploying NGINX via ArgoCD

```bash
kubectl apply -f argocd/application.yaml
kubectl get applications -n argocd
```

Expected:
```
STATUS: Healthy / Synced
```

---

## 5. Accessing the Application

```bash
kubectl get svc nginx-service
```

Visit:
```
http://<NGINX-LB-EXTERNAL-IP>
```

```

---

## Cleanup

```bash
cd terraform
terraform destroy
```

---

## Completion Summary

| Deliverable | Status |
|------------|--------|
| EKS created using Terraform | Completed |
| NGINX deployed |  Completed |
| ArgoCD installed & synced |  Completed |
| Access via LoadBalancer |  Completed |

---

##  Conclusion

I successfully built a GitOps-driven CI/CD workflow on AWS EKS with automatic deployment through ArgoCD.  
The setup demonstrates practical experience across DevOps automation, IaC, GitOps, Kubernetes, containers, and cloud-native security and networking.

---
