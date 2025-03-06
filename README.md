# Terraform GCP Autoscaler Setup

## Overview

This Terraform configuration sets up a **Google Cloud Platform (GCP) Autoscaler** with an **Instance Group Manager (IGM)** and an **Instance Template**. The autoscaler scales instances based on **Pub/Sub undelivered messages**.

## Prerequisites

- **Install Terraform**: [Download & Install](https://developer.hashicorp.com/terraform/downloads)
- **Have a GCP account** with billing enabled
- **Install gcloud CLI**: [Setup Guide](https://cloud.google.com/sdk/docs/install)
- **Authenticate Terraform with GCP**:
  ```sh
  gcloud auth application-default login
  ```
- **Enable required GCP APIs**:
  ```sh
  gcloud services enable compute.googleapis.com
  gcloud services enable monitoring.googleapis.com
  ```

## Deployment Steps

### 1. Clone the Repository
```sh
git clone <repo-url>
cd <repo-directory>
```

### 2. Initialize Terraform
```sh
terraform init
```

### 3. Preview the Infrastructure Changes
```sh
terraform plan
```
This will show the resources that will be created/modified.

### 4. Apply the Configuration
```sh
terraform apply -auto-approve
```
This command will create the resources in GCP.

### 5. Verify Deployment

Check if the instance group and autoscaler are created:
```sh
gcloud compute instance-groups managed list
```

Check autoscaler status:
```sh
gcloud compute autoscalers list
```

## Resources Created

- **Compute Instance Template**: Defines machine type, disk, and network.
- **Compute Instance Group Manager (IGM)**: Manages the instances.
- **Compute Autoscaler**: Scales based on Pub/Sub undelivered messages.
- **Target Pool (Optional)**: Can be used for load balancing.

## Cleanup

To destroy all created resources, run:
```sh
terraform destroy -auto-approve
```

## Troubleshooting

- **Check Terraform logs**:
  ```sh
  terraform apply -auto-approve --debug
  ```
- **Check GCP Compute logs**:
  ```sh
  gcloud logging read "resource.type=gce_instance" --limit 50
  ```
- **Ensure IAM roles are correct**:
  - Compute Admin
  - Monitoring Viewer (for autoscaler metrics)

## Next Steps

- **Add Load Balancer** for traffic distribution.
- **Use Terraform modules** for better scalability.
- **Automate deployments using CI/CD pipelines.**

---
