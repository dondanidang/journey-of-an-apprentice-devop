### Tools
  - **S3**
  - **IAM**
  - **Node and NPM**
  - **AWS CLI**

#### Configure AWS and IAM
  - Create **root user** registering to AWS console
  - User **root user** to create **dev user** with:
    - **Programmatic access**
    - **Access keys**
    - **S3 full access permissions**

#### Configure S3
  - Create **bucket** with:
    - **Name** is same as **application name**
    - **Permissions:**
      - Allow **all public access**
      - **Bucket policy**
        - Use policy generator with:
          - policy type: **S3 bucket policy**
          - effet: **Allow**
          - Principal: **"*"**
          - AWS service: **S3**
          - Actions: **GetObject**
          - ARN: **bucket arn**

#### Configure AWS locally
  - aws configure --profile **profile name**
  - in ~/.aws
    - ./credentials => profiles access keys info
    - ./config => local config of aws

#### Deploy
  - in React app
    aws s3 sync build/ s3://**bucket-name** --profile **profile-name**
