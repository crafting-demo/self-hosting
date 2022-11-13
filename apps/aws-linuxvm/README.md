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

## Unknown Issues

The VSCode server package has native library dependencies. The current
build doesn't work on Amazon Linux because the libc used there is too
old. This example uses Ubuntu AMIs.
