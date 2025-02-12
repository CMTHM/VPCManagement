import json
import boto3

# AWS Clients
ec2 = boto3.client("ec2")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("VPCRecords")

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"])
        cidr_block = body.get("cidr_block", "10.0.0.0/16")
        subnet_cidrs = body.get("subnet_cidrs", ["10.0.1.0/24", "10.0.2.0/24"])

        # Create VPC
        vpc_response = ec2.create_vpc(CidrBlock=cidr_block)
        vpc_id = vpc_response["Vpc"]["VpcId"]

        # Create Subnets
        subnets = []
        for cidr in subnet_cidrs:
            subnet_response = ec2.create_subnet(VpcId=vpc_id, CidrBlock=cidr)
            subnets.append(subnet_response["Subnet"]["SubnetId"])

        # Store in DynamoDB
        table.put_item(Item={"vpc_id": vpc_id, "cidr_block": cidr_block, "subnets": subnets})

        return {
            "statusCode": 201,
            "body": json.dumps({
                "message": "VPC created successfully",
                "vpc_id": vpc_id,
                "subnets": subnets
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
