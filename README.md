# leaky-bucket

A Shell Script that tests for AWS S3 Bucket Misconfiguration

# Requirements

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [jq](https://github.com/stedolan/jq)

Kali / Debian / Ubuntu:
```
apt update
apt install awscli jq
```

RHEL / CentOS:
```
yum install epel-release
yum install awscli jq
```

Arch:
```
pacman -Sy
pacman -S aws-cli jq
```

# Getting Started

Make leaky-bucket executable:
```
chmod +x leaky-bucket.sh
```

# Example

Test a bucket named hello-world:
```
./leaky-bucket hello-world
```
