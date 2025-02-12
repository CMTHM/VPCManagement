import json

def lambda_handler(event, context):
    try:
        token = event.get("authorizationToken", "").replace("Bearer ", "")

        # Dummy Token Validation
        VALID_TOKENS = {
            "valid-token-123": "user123"
        }

        if token in VALID_TOKENS:
            return {
                "principalId": VALID_TOKENS[token],
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
