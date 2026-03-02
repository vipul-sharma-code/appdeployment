README.md
# Main Application & Microservice Project

This repository contains the **Main Application** and **Microservice** built using **NestJS**, deployed on **Amazon EKS** using **Helm charts** and **GitHub Actions**. Environment variables are managed securely via **AWS Secrets Manager** and **ExternalSecrets**. The applications are accessible via **NGINX Ingress Controller**.

---

## **Table of Contents**

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Docker](#docker)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Helm Charts](#helm-charts)
- [Environment Variables](#environment-variables)
- [Ingress Setup](#ingress-setup)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Access & Logs](#access--logs)
- [References](#references)

---

## **Project Structure**


├─ helm/
│ ├─ main-app/ # Helm chart for Main App
│ └─ microservice/ # Helm chart for Microservice
├─ src/
│ ├─ main-app/ # NestJS main app source
│ └─ microservice/ # NestJS microservice source
├─ package.json
├─ package-lock.json
├─ Dockerfile # Multi-stage build
└─ README.md


---

## **Prerequisites**

- Node.js `v18.x`
- npm `>= 9.x`
- Docker
- AWS CLI configured
- kubectl installed
- Helm `>= 3.x`
- AWS EKS cluster with proper IAM roles

---

## **Setup**

Clone the repository:

```bash
git clone https://github.com/<your-org>/<repo-name>.git
cd <repo-name>

Install dependencies:

cd src/main-app
npm install
cd ../microservice
npm install
Docker
Build Docker Image
# Main App
docker build -t main-app:latest ./src/main-app

# Microservice
docker build -t microservice:latest ./src/microservice
Run Locally
docker run -p 3001:3001 main-app:latest
docker run -p 3002:3002 microservice:latest
Kubernetes Deployment

Deploy applications via Helm to EKS:

# Development
helm upgrade --install main-app ./helm/main-app \
  --namespace dev --create-namespace \
  -f ./helm/main-app/values-dev.yaml

helm upgrade --install microservice ./helm/microservice \
  --namespace dev --create-namespace \
  -f ./helm/microservice/values-dev.yaml

Replace dev with staging or prod for other environments.

Helm Charts

values.yaml contains environment-specific settings.

ExternalSecrets fetch environment variables from AWS Secrets Manager.

Example values.yaml snippet:

externalSecret:
  enabled: true
  name: main-app-env
  refreshInterval: 1m
  secretStoreName: aws-secrets-manager
  targetSecretName: main-app-env

refreshInterval can be modified to control how often secrets are synced.

Environment Variables

Stored in AWS Secrets Manager.

Pulled into Kubernetes via ExternalSecrets.

Each app can have its own secret: main-app-env and microservice-env.

Ingress Setup
Dev

Ingress class: nginx

Host: main.dev.example.com

Staging

Separate ingress controller (optional) or reuse nginx controller.

Host: main.staging.example.com

Example Ingress YAML:

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-app-staging
  namespace: staging
  annotations:
    kubernetes.io/ingress.class: "nginx-staging"
spec:
  rules:
    - host: main.staging.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: main-app-service
                port:
                  number: 3001
GitHub Actions CI/CD

Development branch → deployed to dev namespace.

Main branch → deployed to staging namespace.

Deployment steps:

Build Docker image

Push to ECR

Deploy via Helm

Use secrets from AWS Secrets Manager via ExternalSecrets

Example Helm deploy command in GitHub Actions:

helm upgrade --install main-app ./helm/main-app \
  --namespace ${{ steps.vars.outputs.namespace }} \
  --create-namespace \
  --set image.repository=${{ steps.ecr-login.outputs.registry }}/app/${{ env.ECR_MAIN_REPO }} \
  --set image.tag=${{ env.IMAGE_TAG }} \
  -f ./helm/main-app/values-${{ steps.vars.outputs.namespace }}.yaml
Access & Logs

View logs:

kubectl logs -n dev deployment/main-app
kubectl logs -n dev deployment/microservice

Restart pods:

kubectl rollout restart deployment main-app -n dev
kubectl rollout restart deployment microservice -n dev



---

This README:

- Explains project structure, Docker, Helm, and secrets.  
- Covers dev/staging/prod deployment.  
- Includes Ingress setup and GitHub Actions example.  
- Is ready for any new developer to start.  

---
