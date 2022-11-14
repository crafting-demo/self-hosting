# Sandbox with Dedicated Linux VM as Coding Env

This example runs Terraform in the sandbox resource to provision
a Linux VM with VSCode server.

The workspace exposes proxy endpoints to access the Linux VM via
a Web Terminal (over SSH) or using a Web IDE.

Because SSH is enabled in the VM, local VSCode can also be launched
using SSH Remote Development.

## Target Scenario

This example targets self-hosting deployment in a private VPC (no 
inbound Internet access), and thus disabled Auth Proxy on the endpoints.
The private IPs are used for direct access, assuming the developers
connect VPN before starting work.

## Setup

This example provides a minimal template as a solution for the target
scenario. Before adopting this template, there are a few things to be
considered regarding setup.

### SSH Keypairs

There are at least 2 clients who will access the VM after creating the sandbox:

- The workspace in the sandbox.
  The Web Terminal is running under the identity of the sandbox owner and use
  SSH to establish the terminal to the VM.
  The public key is automatically authorized during the VM setup.
- The user using a local machine (outside the sandbox, e.g. a laptop).
  This solution in this example can be replaced by an actual practice in use.
  Only for demonstration, this example automatically authorizes key pairs
  matching the tag:

    ```
    OwnerEmail = $SANDBOX_OWNER_EMAIL
    ```

  Given that, the user must create a keypair in EC2 and added a tag `OwnerEmail`
  with the value of the email used to login to the Sandbox system.

### EC2 Launch Template

This example uses an EC2 launch template for both the simplicity and flexibility.
When adopting this example, an EC2 launch template must be pre-created and replace
the value of Terraform variable `launch_template` to be the name of the launch
template.
Most of the details can be configured in the launch template, including AMI,
default instance type, disk sizes, etc.
It's important to specify the subnets and security groups correctly in the launch
template:

- The subnets must be accessible from the sandbox workspaces (in the same subnets
  as the Sandbox hosting EKS cluster or they are routable from the EKS cluster);
- The security groups must allow the inbound access from the Sandbox hosting EKS
  cluster (or simply include the EKS cluster security group).

The subnets and security groups must be specified either in the launch template or
in the Terraform configuration (see `main.tf`), but not in both places (due to 
the limitation of the current aws provider).

## Unknown Issues

The VSCode server package has native library dependencies. The current
build doesn't work on Amazon Linux because the libc used there is too
old. This example uses Ubuntu AMIs.
