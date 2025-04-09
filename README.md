

# Serverless Netzence CRUD API Deployment

## Overview

This repository provides an Infrastructure as Code (IaC) solution for deploying a simple serverless CRUD (Create, Read, Update, Delete) API using AWS services. The application includes the following components:

- **API Gateway**: Manages HTTP requests and exposes the API endpoints.
- **Lambda Functions**: Handle CRUD operations on a DynamoDB table.
- **DynamoDB**: Stores the items for the CRUD operations.

The deployment and infrastructure setup are managed using the **AWS Serverless Application Model (AWS SAM)**, which simplifies the creation and management of serverless applications. With a single command, you can deploy the entire solution.

## Architecture

The application architecture consists of the following components:

1. **API Gateway**:
    - Exposes four API endpoints for CRUD operations:
      - `GET /items`: Retrieves all items from DynamoDB.
      - `GET /items/{id}`: Retrieves a specific item by its ID.
      - `PUT /items`: Creates or updates an item in DynamoDB.
      - `DELETE /items/{id}`: Deletes an item by its ID from DynamoDB.

2. **Lambda Functions**:
    - The Lambda functions contain the business logic to interact with DynamoDB.
    - They are triggered by the HTTP requests sent to the API Gateway.

3. **DynamoDB Table**:
    - Stores the items for the CRUD API. The table uses `id` as the partition key, and the table name is `crud-items`.

## Pre-requisites

Before you begin, ensure that the following tools are installed and configured:

- **AWS CLI**: Ensure that you have the AWS CLI installed and configured with your credentials. [AWS CLI Installation](https://aws.amazon.com/cli/)
- **AWS SAM CLI**: Install the AWS SAM CLI to deploy the serverless application. Follow the [official installation guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) if necessary.
- **Node.js**: The Lambda functions in this project are written in Node.js 18.x.

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/DanAletor/crud-api.git
cd crud-api
```

### 2. Build the Application

Run the following command to build the application:

```bash
sam build
```

This will prepare the Lambda functions and other resources for deployment.

### 3. Deploy the Application

Deploy the serverless application using the `sam deploy --guided` command:

```bash
sam deploy --guided
```

During the guided deployment, you will be prompted to configure the following settings:

- **Stack Name**: Name of the CloudFormation stack (default is `sam-app`).
- **AWS Region**: Select the AWS region where you want to deploy the resources (default is `eu-west-3`).
- **Confirm changes before deploy**: Choose whether to confirm changes before deployment (default is `n`).
- **Allow SAM CLI IAM role creation**: Allow SAM CLI to create necessary IAM roles (default is `y`).
- **Disable rollback**: Choose whether to disable rollback in case of deployment failures (default is `n`).
- **Save arguments to configuration file**: Choose whether to save deployment configurations for future use (default is `y`).

Once the deployment is complete, you will see output similar to the following:

```
Outputs:
  ApiEndpoint:
    Description: "The invoke URL for our HTTP API"
    Value: https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items
  Function:
    Description: "DynamoDB handler function ARN"
    Value: arn:aws:lambda:eu-west-3:123605679960:function:sam-app-DDBHandlerFunction-3KMELETFtDF9
```

The output confirms that the API has been successfully deployed.

### 4. Test the API

You can now test the API using the provided `ApiEndpoint`. You can use tools like Postman or cURL to test the following endpoints:

- **GET /items**: Retrieve a list of all items in DynamoDB.
- **GET /items/{id}**: Retrieve a specific item by its ID.
- **PUT /items**: Create or update an item.
- **DELETE /items/{id}**: Delete an item by its ID.

Below are examples for testing the CRUD operations.

---

### **1. Create (PUT /items)**

**Description**: Create or update an item with ID `1`, name `netzence`, and price `500`.

#### Example using cURL:

```bash
curl -X PUT https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items \
-H "Content-Type: application/json" \
-d '{"id": "1", "name": "netzence", "price": 500}'
```

#### Example using Postman:
- Method: `PUT`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items`
- Body: 
  - Select `raw` and `JSON` format
  - Paste the following JSON:
  ```json
  {
    "id": "1",
    "name": "netzence",
    "price": 500
  }
  ```

---

### **2. Read (GET /items)**

**Description**: Retrieve all items stored in DynamoDB.

#### Example using cURL:

```bash
curl -X GET https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items
```

#### Example using Postman:
- Method: `GET`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items`
- Click `Send`.

---

### **3. Read (GET /items/{id})**

**Description**: Retrieve a specific item by its ID, e.g., ID `1`.

#### Example using cURL:

```bash
curl -X GET https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items/1
```

#### Example using Postman:
- Method: `GET`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items/1`
- Click `Send`.

---

### **4. Update (PUT /items)**

**Description**: Update an existing item. For example, change the price of `netzence` to `600`.

#### Example using cURL:

```bash
curl -X PUT https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items \
-H "Content-Type: application/json" \
-d '{"id": "1", "name": "netzence", "price": 600}'
```

#### Example using Postman:
- Method: `PUT`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items`
- Body: 
  - Select `raw` and `JSON` format
  - Paste the following JSON:
  ```json
  {
    "id": "1",
    "name": "netzence",
    "price": 600
  }
  ```

---

### **5. Delete (DELETE /items/{id})**

**Description**: Delete an item by its ID (e.g., ID `1`).

#### Example using cURL:

```bash
curl -X DELETE https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items/1
```

#### Example using Postman:
- Method: `DELETE`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items/1`
- Click `Send`.

---

## IAM Permissions

For security, the Lambda function is granted the `DynamoDBCrudPolicy` IAM role, which allows only the necessary permissions to interact with the DynamoDB table. This policy is automatically applied during deployment using SAM.

## Environment Variables

The Lambda function uses the following environment variable:

- **TABLE_NAME**: The name of the DynamoDB table. It is set on `github-actions`.

## Resources Defined

- **DynamoDB Table**: `crud-items` with a partition key `id` of type String.
- **Lambda Function**: Handles the CRUD operations on DynamoDB.
- **API Gateway**: Defines the HTTP routes and triggers the Lambda functions.
- **IAM Role**: Provides permissions to the Lambda function to access DynamoDB.

## Troubleshooting

If you encounter issues, try the following:

1. **Deployment Failures**:
   - Ensure your AWS CLI is properly configured with the correct IAM credentials.
   - If the deployment fails, check the CloudFormation console for detailed error logs.

2. **IAM Permissions**:
   - Make sure your IAM user has permissions to deploy Lambda functions, API Gateway, and DynamoDB.

3. **API Not Responding**:
   - Verify that the API Gateway has been deployed successfully.
   - Ensure that the Lambda function is correctly configured with the necessary environment variables.

## Cleanup

To remove all deployed resources, run the following command:

```bash
sam delete
```

This will delete the CloudFormation stack and all associated resources, including the Lambda function, DynamoDB table, and API Gateway.


### **CI/CD Pipeline Documentation for Serverless Node.js Application**

This document explains the structure of the CI/CD pipeline that automatically deploys an AWS Lambda function whenever code is pushed to the `main` branch of the repository. The pipeline includes steps for code linting, building the application, deploying it to AWS, running post-deployment tests, and handling rollbacks in case of failure.

---

### **Pipeline Structure:**

```yaml
name: Deploy Serverless Node.js Application

on:
  push:
    branches:
      - main
```

**Explanation:**
- This pipeline is triggered whenever there is a push to the `main` branch. It ensures that the latest code changes are automatically deployed after validation and testing.

---

### **Job 1: Install (Runs on Ubuntu Latest)**

This job installs dependencies, sets up the environment, and prepares the application for deployment.

#### **Step 1: Checkout Code**
```yaml
- name: Checkout Code
  uses: actions/checkout@v3
```
**Explanation:**
- This step checks out the latest code from the repository so that subsequent steps can work with the current version of the codebase.

#### **Step 2: Set up Node.js**
```yaml
- name: Set up Node.js
  uses: actions/setup-node@v3
  with:
    node-version: '18'
```
**Explanation:**
- This step sets up Node.js version `18` in the pipeline. It ensures that the correct version of Node.js is available to run the application and install dependencies.

#### **Step 3: Install Dependencies**
```yaml
- name: Install Dependencies
  run: |
    npm install
```
**Explanation:**
- This step installs the Node.js application dependencies defined in `package.json` by running `npm install`.

#### **Step 4: Lint Code**
```yaml
- name: Lint Code
  run: |
    npm install --save-dev eslint
    npx eslint . --ignore-path .gitignore || true
```
**Explanation:**
- This step installs ESLint (if not already present) and runs it to check for any style issues in the code. The `--ignore-path .gitignore` ensures that files listed in `.gitignore` are excluded from linting. The `|| true` allows the pipeline to continue even if lint errors are found, but this can be adjusted to fail the build if desired.

#### **Step 5: Install AWS SAM CLI**
```yaml
- name: Install AWS SAM CLI
  run: |
    pip install aws-sam-cli
```
**Explanation:**
- This step installs the AWS Serverless Application Model (SAM) CLI, which is used for building, testing, and deploying serverless applications.

#### **Step 6: Build Application with AWS SAM**
```yaml
- name: Build Application with AWS SAM
  run: |
    sam build
```
**Explanation:**
- This step builds the serverless application using the AWS SAM CLI. It compiles the code and prepares it for deployment by creating the necessary artifacts and packaging them.

---

### **Job 2: Deploy (Runs on Ubuntu Latest)**

This job deploys the Lambda function using AWS SAM after the application is built.

#### **Step 1: Checkout Code**
```yaml
- name: Checkout Code
  uses: actions/checkout@v3
```
**Explanation:**
- This step ensures that the latest version of the code is checked out for the deployment job. It ensures that the code being deployed is always the most recent version.

#### **Step 2: Set up AWS Credentials**
```yaml
- name: Set up AWS Credentials
  uses: aws-actions/configure-aws-credentials@v2
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: eu-west-3
```
**Explanation:**
- This step configures AWS credentials to allow the workflow to interact with AWS services. It uses GitHub secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) for security and defines the AWS region (`eu-west-3`).

#### **Step 3: Get Current Lambda Version**
```yaml
- name: Get Current Lambda Version
  id: get_lambda_version
  run: |
    CURRENT_VERSION=$(aws lambda list-versions-by-function --function-name sam-app-DDBHandlerFunction-3KMELETFtDF9 --query 'Versions[?Version!=`$LATEST`].Version' | jq '.[-1]' -r)
    echo "CURRENT_VERSION=$CURRENT_VERSION" >> $GITHUB_ENV
    echo "Current version: $CURRENT_VERSION"
```
**Explanation:**
- This step fetches the current version of the Lambda function (`sam-app-DDBHandlerFunction-3KMELETFtDF9`) by listing all versions except for `$LATEST` and storing the most recent version in an environment variable. The version is used later for rollback in case of failure.

#### **Step 4: Deploy to AWS SAM Stack**
```yaml
- name: Deploy to AWS SAM Stack
  run: |
    sam deploy \
      --stack-name sam-app \
      --region eu-west-3 \
      --no-confirm-changeset \
      --capabilities CAPABILITY_IAM \
      --resolve-s3 \
      --no-fail-on-empty-changeset
```
**Explanation:**
- This step uses AWS SAM to deploy the Lambda function to the AWS environment. It specifies the stack name (`sam-app`), the AWS region, and IAM capabilities necessary for deployment. The `--no-confirm-changeset` flag prevents the user from having to confirm changes, while `--no-fail-on-empty-changeset` allows the deployment to succeed even if there are no changes.

#### **Step 5: Get Latest Lambda Version ARN**
```yaml
- name: Get Latest Lambda Version ARN
  id: get_lambda_deployed_version
  run: |
    LAMBDA_ARN=$(aws lambda get-function --function-name sam-app-DDBHandlerFunction-3KMELETFtDF9 --query 'Configuration.FunctionArn' --output text)
    echo "LAMBDA_ARN=$LAMBDA_ARN" >> $GITHUB_ENV
    echo "Deployed Lambda ARN: $LAMBDA_ARN"
```
**Explanation:**
- This step retrieves the ARN (Amazon Resource Name) of the deployed Lambda function for future reference, logging it to the GitHub environment.

---

### **Job 3: Test (Runs on Ubuntu Latest)**

This job runs post-deployment tests to verify the correctness of the deployment.

#### **Step 1: Checkout Code**
```yaml
- name: Checkout Code
  uses: actions/checkout@v3
```
**Explanation:**
- This step ensures that the latest code is checked out for the test job, ensuring the test is run against the most recent version of the application.

#### **Step 2: Make Post-Deployment Test Script Executable**
```yaml
- name: Make post-deployment test script executable
  run: |
    chmod +x ./post_deploy_test.sh
```
**Explanation:**
- This step makes the `post_deploy_test.sh` script executable so that it can be run in the next step.

#### **Step 3: Run Post-Deployment Tests**
```yaml
- name: Run Post-Deployment Tests
  run: |
    export ENDPOINT=${{ secrets.ENDPOINT }}
    ./post_deploy_test.sh
```
**Explanation:**
- This step runs the `post_deploy_test.sh` script to perform automated tests all endpoints of the deployed application. It uses an environment variable (`ENDPOINT`) stored as a GitHub secret to interact with the deployed service. The script is expected to test the Lambda function endpoint and ensure it is working as expected.

---

### **Job 4: Rollback (Runs on Ubuntu Latest)**

This job handles rollback in case of deployment failure and rund only if the tests fails on not.

#### **Step 1: Checkout Code**
```yaml
- name: Checkout Code
  uses: actions/checkout@v3
```
**Explanation:**
- This step ensures that the latest version of the code is available for the rollback process.

#### **Step 2: Rollback Lambda Function to Previous Version**
```yaml
- name: Rollback Lambda Function to Previous Version
  run: |
    PREVIOUS_VERSION=$CURRENT_VERSION
    aws lambda update-alias \
      --function-name sam-app-DDBHandlerFunction-3KMELETFtDF9 \
      --name staging \
      --function-version $PREVIOUS_VERSION
    echo "Rolled back to version $PREVIOUS_VERSION"
```
**Explanation:**
- If the deployment fails, this step will roll back the Lambda function to the version stored in the `CURRENT_VERSION` environment variable, which was captured earlier in the `deploy` job. It updates the alias `staging` to point to the previous version of the Lambda function.

---

### **Conclusion**

This CI/CD pipeline automates the process of deploying an AWS Lambda function whenever new code is pushed to the `main` branch. It includes steps for code linting, building the application, deploying to AWS, running post-deployment tests, and handling rollbacks if necessary. By using GitHub Actions, this pipeline ensures that the Lambda function is continuously delivered and tested in an efficient and reliable manner.

