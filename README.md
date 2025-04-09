

# Serverless CRUD API Deployment

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
git clone https://github.com/your-repository.git
cd your-repository
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
-d '{"id": 1, "name": "netzence", "price": 500}'
```

#### Example using Postman:
- Method: `PUT`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items`
- Body: 
  - Select `raw` and `JSON` format
  - Paste the following JSON:
  ```json
  {
    "id": 1,
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
-d '{"id": 1, "name": "netzence", "price": 600}'
```

#### Example using Postman:
- Method: `PUT`
- URL: `https://nachrf8gvc.execute-api.eu-west-3.amazonaws.com/items`
- Body: 
  - Select `raw` and `JSON` format
  - Paste the following JSON:
  ```json
  {
    "id": 1,
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

- **TABLE_NAME**: The name of the DynamoDB table. It is set to `crud-items`.

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

## Conclusion

You have successfully deployed a serverless CRUD API using AWS SAM. This API can handle basic CRUD operations with DynamoDB using Lambda and API Gateway.

