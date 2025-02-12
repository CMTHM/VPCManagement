import json
import boto3

# AWS Clients
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("VPCRecords")

def lambda_handler(event, context):
    try:
        vpc_id = event["pathParameters"]["vpc_id"]

        # Fetch VPC details from DynamoDB
        response = table.get_item(Key={"vpc_id": vpc_id})

        if "Item" not in response:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "VPC not found"})
            }

        return {
            "statusCode": 200,
            "body": json.dumps(response["Item"])
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
