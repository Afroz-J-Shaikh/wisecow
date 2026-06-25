import os
import boto3
import sys

print("This script backs up your directory from local to AWS S3")

def backup():
    bucket = input("Enter your S3 bucket name : ")
    s3 = boto3.client('s3')
    try:
        s3.head_bucket(Bucket=bucket)
    except:
        print("Bucket does not exist")
        sys.exit(1)

    directory = input("Enter the directory path : ")

    if not os.path.isdir(directory):
        print("Invalid directory. Please try again.")
        sys.exit(1)

    for root, dirs, files in os.walk(directory):
        for file in files:
            local_path = os.path.join(root, file)
            relative_path = os.path.relpath(local_path, directory)
            try:
                s3.upload_file(local_path, bucket, relative_path)
            except:
                print("Failed to upload.")
                sys.exit(1)

    print(f"\nBackup complete! Successfully uploaded all the files.")

backup()