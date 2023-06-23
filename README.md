
# Terraform Infrastructure Repository

This repository contains Terraform configurations to manage infrastructure in multiple cloud providers like AWS, Google Cloud, Oracle Cloud, and NetCup.

## Directory Structure

- `providers/` - Contains provider configuration files for each cloud service provider.
- `plans/` - Contains individual Terraform configurations for different infrastructure components. 

## Usage

1. Define your cloud provider credentials as environment variables or in a `.tfvars` file. Do not commit your `.tfvars` file with secrets into version control.

2. Navigate to the directory of the infrastructure component you want to manage:

```bash
cd plans/<infrastructure_component>
```

3. Initialize the Terraform working directory:

```bash
terraform init
```

4. Create a new execution plan:

```bash
terraform plan
```

5. Apply the changes required to reach the desired state of the configuration:

```bash
terraform apply
```

## Providers

- **AWS:** Configure your AWS access keys as environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. The region is set to "us-west-2" by default in `providers/aws.tf`.

- **Google Cloud, Oracle Cloud, NetCup:** Please refer to the respective `.tf` files in the `providers/` directory for configuration details.

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue or Slack with the owners of this repository.

---

Please adjust and expand this README.md according to your project's needs. This is just a starting point and does not cover all the details of your specific project.