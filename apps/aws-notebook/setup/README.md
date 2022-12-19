# Setup Sample

This folder contains sample Terraform module for the initial setup
in a new AWS account.

When used in a real-world project, please use this as a reference and integrate
with your own Terraform configuration with necessary modifications.

## Configurations

This module creates:

- A new VPC:
  - Private subnets per each availability zone;
  - Client VPN Gateway endpoint for accessing the VPC;
  - (Optionally) Public subnets per each availability zone to allow Internet access from private subnets;
  - An ECS cluster;
  - An ECS Task Execution Role.
