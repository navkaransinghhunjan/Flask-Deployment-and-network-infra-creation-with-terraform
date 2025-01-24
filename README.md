# Flask Deployment with Terraform

This repository contains Terraform code for deploying a Flask application on AWS. The infrastructure is created and managed using Infrastructure as Code (IaC) principles with Terraform.

---

## Features

- **AWS VPC:** A custom Virtual Private Cloud (VPC) with a public subnet.
- **Flask Application Deployment:** Deploys a simple Flask application on an EC2 instance.
- **Security Group:** Configures security groups for SSH and HTTP access.
- **Provisioners:** Installs Flask, copies the application code, and runs the Flask server on the EC2 instance.
- **Key Pair Management:** Uses an existing SSH key pair for instance authentication.

---

## Architecture Overview

1. **VPC:** A custom VPC is created with the CIDR block `10.0.0.0/16`.
2. **Subnet:** A public subnet is configured within the VPC.
3. **Internet Gateway:** Enables internet access for the EC2 instance.
4. **EC2 Instance:** Hosts the Flask application.
5. **Security Group:** 
   - Allows inbound SSH traffic (port 22) from anywhere.
   - Allows inbound HTTP traffic (port 80) from anywhere.

---

## Prerequisites

1. **AWS CLI Installed:** [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
2. **Terraform Installed:** [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
3. **SSH Key Pair:**
   - Ensure an SSH key pair exists on your system (`~/.ssh/id_ed25519`).
   - Update the path in the Terraform code if using a different key.
4. **AWS Account:**
   - Configure your credentials using `aws configure`.

---

## Getting Started

1. Clone this repository:
   ```bash
   git clone git@github.com:navkaransinghhunjan/infra-with-terraform.git
   cd infra-with-terraform
