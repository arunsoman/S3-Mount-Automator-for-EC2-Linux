# S3 Mount Automator for EC2 & Linux

This repository provides scripts and automation for mounting AWS S3 buckets to Linux-based systems, including Amazon EC2 instances. With multiple solutions for different environments, this tool makes mounting S3 as a local filesystem easier, supports persistence across reboots, and ensures proper testing of the mount process.

## Features

- **Automated S3 Mounting**: Easily mount AWS S3 buckets to local directories on EC2 or any Linux instance.
- **AWS Credentials Management**: Supports automated credential handling or manual entry, with secure storage.
- **Multiple Mounting Methods**: Use `s3fs-fuse`, IAM roles, or other AWS-specific tools to mount S3 buckets.
- **Test and Verify Mount**: After mounting, the script creates a test folder, verifies the S3 mount, and cleans up the test environment.
- **Persistence**: Automatically configures `/etc/fstab` to ensure mounted directories persist across system reboots.
- **Error Handling**: Provides detailed error messages and logs to assist with troubleshooting.

## Supported Use Cases

1. **Mounting S3 Buckets on EC2 Instances**: This script supports mounting S3 buckets as a filesystem on an EC2 instance, using IAM roles or access/secret keys.
2. **Mounting S3 Buckets on Any Linux Instance**: Use this tool on any Linux environment, whether it’s an EC2 instance or an on-premises machine, to mount S3 buckets.
3. **Testing Mounts**: Verify that the S3 bucket is properly mounted by creating a test folder and confirming its presence in S3.
4. **Persistent Mounting**: Ensure the S3 bucket is automatically remounted after system restarts.

## Installation

### Prerequisites

- Linux-based system (EC2 instance or other Linux machines).
- AWS IAM credentials with appropriate permissions to access S3.
- AWS CLI installed for listing and interacting with S3 buckets.
- `s3fs-fuse` installed for mounting the S3 bucket.

### Setup

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/arunsoman/s3-mount-automator-ec2-linux.git
    cd s3-mount-automator-ec2-linux
    ```

2. **Make the Script Executable**:
    ```bash
    chmod +x mount_s3_folder.sh
    ```

3. **Run the Script**:
    ```bash
    ./mount_s3_folder.sh
    ```

    The script will guide you through the process of listing folders in the S3 bucket, choosing a folder to mount, and verifying the mount process.

## How It Works

1. **AWS Credentials Handling**: 
   - The script checks for the presence of the `~/.s3Access` file. If it doesn’t exist, you will be prompted to input your AWS credentials, which are then securely stored.
   - If you are using IAM roles on your EC2 instance, no need to provide credentials.
   
2. **Listing and Selecting S3 Folders**:
   - The script lists all folders (prefixes) in the specified S3 bucket and allows you to select one for mounting.
   
3. **Mounting the Selected Folder**:
   - After selecting a folder, you will specify a local directory where the folder will be mounted.
   - The mount operation uses `s3fs-fuse` and allows for persistent mounting across reboots by updating `/etc/fstab`.

4. **Test Mounting**:
   - A test folder is created within the mounted directory, and the script verifies its existence in the S3 bucket.
   - If successful, the folder is deleted both locally and from S3, and a success message is displayed.
   - If the test fails, the script provides clear error messages and suggests reviewing logs.

## Example Usage

1. **List Available Folders**:
    The script lists all the folders in the specified S3 bucket for selection.

2. **Mount a Folder**:
    Select a folder and choose a local mount point.

3. **Verify the Mount**:
    The script creates a test folder in the mounted directory, verifies it in S3, and cleans up if successful.

4. **Persistence Across Reboots**:
    The script automatically configures the mount to persist across system reboots by updating `/etc/fstab`.

## Troubleshooting

- Ensure your AWS credentials are correct and have the appropriate S3 permissions.
- Check that `s3fs-fuse` is installed and properly configured.
- Review error messages and logs if the mount fails, and double-check AWS IAM role permissions if needed.

## Contributions

We welcome contributions to the project. Feel free to submit pull requests or report issues to improve functionality and support more use cases.

## License

This project is licensed under the MIT License.
