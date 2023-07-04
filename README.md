# Terraform Infrastructure Overview

This Terraform project provisions and manages a highly available, multi-region infrastructure on AWS. It uses the HashiCorp Configuration Language (HCL) and the AWS provider for Terraform.

## High-Level Structure

The infrastructure primarily consists of resources spanning across multiple regions. Each region has its own Virtual Private Cloud (VPC), Internet Gateway (IGW), subnets, and EC2 instances. All of these components are isolated within each region.

EC2 instances are created in each region with specific security group rules. An Elastic IP (EIP) is associated with each instance, and each instance can be optionally launched with an additional EBS volume.

In addition, this project is set up to use Terraform modules, enabling reuse of common resource configurations. Each module defines a distinct set of related resources, such as EC2 instances or security groups.

## Terraform Cloud

Terraform Cloud is used as a remote backend for storing the Terraform state file and for running Terraform operations. 

### State File Storage

Storing the state file remotely on Terraform Cloud provides several advantages including:

- **State File Locking**: This prevents concurrent state operations, which can result in corrupt or inconsistent state files.
- **Versioning**: Each change is versioned, allowing you to track and even revert changes if necessary.
- **Security**: The state file, which can contain sensitive information, is stored securely in the cloud instead of locally.
- **Sharing and Collaboration**: Team members can use the same state file, making collaboration easier.

### Runs Execution

Terraform Cloud also allows executing runs remotely. These runs are triggered whenever changes are pushed to the corresponding Git repository. This process includes:

1. **Plan**: Terraform creates an execution plan detailing what it will do to reach the desired state of the infrastructure.
2. **Apply**: After manual approval of the plan, Terraform applies the changes.
3. **State Update**: The state file is updated to reflect the new infrastructure state.
4. **Outputs**: Once the infrastructure is successfully deployed, Terraform Cloud will display all the outputs that you have defined in your Terraform configuration. This provides a way to extract necessary details from the deployed infrastructure. The output values can also be accessed via the Terraform Cloud API for further automation tasks or CI/CD pipeline integrations.
It's important to note that the output values are part of the state file and get updated whenever the state file changes.

This workflow promotes Infrastructure as Code (IaC) best practices and enables a version-controlled, collaborative approach to infrastructure management. 

---

For more detailed information, please refer to individual Terraform files, which contain comments explaining the purpose and usage of each resource.
