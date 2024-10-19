#!/bin/bash

# Update and install s3fs
sudo apt-get update
sudo apt-get install -y s3fs

# Check if ~/.s3Access exists, if not, create it with user input
if [ ! -f ~/.s3Access ]; then
    echo "~/.s3Access not found, creating it now..."
    echo "Please enter your AWS_ACCESS_KEY_ID:"
    read AWS_ACCESS_KEY_ID
    echo "Please enter your AWS_SECRET_ACCESS_KEY:"
    read AWS_SECRET_ACCESS_KEY

    # Create the credentials file in ~/.s3Access
    echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > ~/.s3Access
    chmod 600 ~/.s3Access
else
    echo "~/.s3Access found, using existing credentials."
fi

# Install AWS CLI (if not installed) to list S3 buckets and objects
if ! command -v aws &> /dev/null; then
    sudo apt-get install -y awscli
fi

# List all folders in the S3 bucket
echo "Fetching folders from S3 bucket 'abmmc-salary'..."
aws s3 ls s3://abmmc-salary/ --recursive | awk -F/ '{print $1}' | sort -u

# Ask the user to select a folder to mount
echo "Please enter the folder name from the above list to mount:"
read folder_to_mount

# Ask the user where they want to mount the folder
echo "Enter the path where you want to mount the S3 folder (e.g., /home/ubuntu/s3-salary):"
read mount_point

# Create the mount point directory if it doesn't exist
mkdir -p "$mount_point"

# Mount the selected folder in the S3 bucket
s3fs abmmc-salary:"$folder_to_mount" "$mount_point" -o passwd_file=~/.s3Access -o allow_other

# Add the S3 mount to /etc/fstab for persistence across reboots
echo "s3fs#abmmc-salary:/${folder_to_mount} ${mount_point} fuse _netdev,allow_other,use_path_request_style,passwd_file=/home/ubuntu/.s3Access 0 0" | sudo tee -a /etc/fstab

# Test the mount by creating a test folder in the mounted directory
test_folder="$mount_point/test_s3_mount"
mkdir -p "$test_folder"

# Verify that the folder was successfully created in the S3 bucket
echo "Checking if the test folder was successfully created in S3..."

if aws s3 ls "s3://abmmc-salary/${folder_to_mount}/test_s3_mount/" &> /dev/null; then
    echo "Test folder successfully created in S3. Now deleting the test folder..."
    rm -r "$test_folder"
    aws s3 rm "s3://abmmc-salary/${folder_to_mount}/test_s3_mount/" --recursive
    echo "Test folder successfully deleted from both the local mount and S3."
else
    echo "Failed to create the test folder in S3. Please check the logs and configuration."
fi
