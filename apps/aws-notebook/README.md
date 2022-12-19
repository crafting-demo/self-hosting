# Application For Jupyter Notebook

This example demonstrates how to run a Jupyter Notebook from a Crafting Sandbox with cell executed remotely
in a provided AWS ECS cluster.

It uses sandbox lifecycle to dynamically provision a Jupyter Notebook remote runtime environment in an ECS cluster
and tears it down when sandbox is deleted.

The developer can access the notebook directly from the sandbox endpoint and start work right after the sandbox is ready.

## Minimum Configuration

This example depends on:

- An existing AWS ECS cluster;
- A role for ECS task execution (attached policy `AmazonECSTaskExecutionRolePolicy`);
- At least one subnet (private) to deploy the ECS task for running notebook cells;
- OpenVPN configuration to access the subnet for connecting to the ECS task from the sandbox.

Please refer to [setup](setup/README.md) for the sample Terraform module to provision above resources in a new AWS account.
If AWS Client VPN Gateway endpoint is used, the `split_tunnel` is configured to `true` as the sandbox needs Internet access,
or additional configuration can be applied so the traffic from the sandbox will be routed through the VPC.

## Customizations

Please refer to the _resources.ecs_ part of [app.yaml](app.yaml) and apply the following customizations:

- Workspace env:
  - `AWS_CONFIG_FILE`: required, the path to config file for AWS CLI stored as a secret;
  - `OPENVPN_CONFIG_FILE`: required, the path to the OpenVPN config file stored as a secret to connect to the private VPC;
- Terraform vars (see [variables.tf](tf/variables.tf) for the details):
  - `ecs_cluster_name`: the name of the ECS cluster;
  - `ecs_task_exec_role_arn`: the ARN of the role for ECS task execution;
  - `subnet_ids`: the subnets for the ECS tasks, at least one must be specified, in JSON string;
  - `security_group_ids`: explicit security groups attaching to the ECS task, in JSON string.
  - `ecs_task_image`: the container image for ECS tasks, please customize using the [reference](images/task/Dockerfile).
