import json
import boto3

# Initialize Secrets Manager client
secrets_client = boto3.client("secretsmanager")

# Hardcoded Secret Name
SECRET_NAME = "vpc-auth-secret"  # Replace with your actual secret name

def get_valid_tokens():
    """Fetch valid tokens from AWS Secrets Manager"""
    try:
        response = secrets_client.get_secret_value(SecretId=SECRET_NAME)
        secret_data = json.loads(response["SecretString"])
        return secret_data.get("valid_tokens", {})  # Ensures function returns a valid dictionary
    except Exception as e:
        print(f"Error fetching secret: {str(e)}")
        return {}

def lambda_handler(event, context):
    try:
        token = event.get("authorizationToken", "").replace("Bearer ", "")
         
        # Fetch valid tokens from AWS Secrets Manager
        valid_tokens = get_valid_tokens()

        if token in valid_tokens:
            return {
                "principalId": valid_tokens[token],
                "policyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Action": "execute-api:Invoke",
                            "Effect": "Allow",
                            "Resource": event["methodArn"]
                        }
                    ]
                }
            }

        return {
            "principalId": "unauthorized",
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Action": "execute-api:Invoke",
                        "Effect": "Deny",
                        "Resource": event["methodArn"]
                    }
                ]
            }
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})  
        }
