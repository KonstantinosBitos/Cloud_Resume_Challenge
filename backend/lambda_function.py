import json
import boto3
import os
import time
import hashlib
from decimal import Decimal
from botocore.exceptions import ClientError

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')

# Get table names from environment variables
counter_table_name = os.environ.get('TABLE_NAME')
visitor_table_name = os.environ.get('VISITOR_TABLE_NAME')

counter_table = dynamodb.Table(counter_table_name)
visitor_table = dynamodb.Table(visitor_table_name)

def lambda_handler(event, context):
    """Lambda function to count total hits AND unique visitors."""
    
    # Get the IP Address
    request_context = event.get('requestContext', {})
    # Try HTTP API V2 path
    ip_address = request_context.get('http', {}).get('sourceIp')
    # If not found, try REST API path
    if not ip_address:
        ip_address = request_context.get('identity', {}).get('sourceIp')
    
    # fallback 
    if not ip_address:
        print("No IP found. Using placeholder.")
        ip_address = "unknown_ip"

    # Always Increment the total Hit Counter
    total_count = update_counter(key_id='total')

    # Hash the IP address for privacy 
    hashed_ip = hashlib.sha256(ip_address.encode('utf-8')).hexdigest()

    # TTL: 24 hours from now 
    now = int(time.time())
    ttl_window = 86400  
    expires_at = now + ttl_window

    unique_count = 0
    is_new_visitor = False

    try:
        # Try to add the visitor hash to the Visitor Table, only succeed if it doesn't already exist
        visitor_table.put_item(
            Item={
                'visitor_id': hashed_ip,
                'expires_at': expires_at
            },
            ConditionExpression='attribute_not_exists(visitor_id)'
        )
        
        # If the write succeeded, it's a NEW visitor
        is_new_visitor = True
        print(f"New visitor detected: {hashed_ip}")

    except ClientError as e:
        # If the condition detected the item exists, it's a returning visitor
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            print(f"Returning visitor detected: {hashed_ip}")
            is_new_visitor = False
        else:
            print(f"DynamoDB Error: {e}")
            # In case of error, we can just fetch the current unique count without incrementing
            is_new_visitor = False

    # Update or Fetch the UNIQUE Counter
    if is_new_visitor:
        # It's a new visitor, so increment the 'unique' counter
        unique_count = update_counter(key_id='unique')
    else:
        # It's a returning visitor, just read the current 'unique' count
        unique_count = get_counter(key_id='unique')

    # Return Both Counts
    return {
        'statusCode': 200,
        'headers': cors_headers(),
        'body': json.dumps({
            'count': total_count,         # Total page loads
            'unique_count': unique_count  # Unique people
        })
    }

def update_counter(key_id):
    """Atomically increments a counter in DynamoDB and returns the new value."""
    try:
        response = counter_table.update_item(
            Key={'id': key_id},
            UpdateExpression='SET #v = if_not_exists(#v, :zero) + :val',
            ExpressionAttributeNames={'#v': 'views'},
            ExpressionAttributeValues={':val': 1, ':zero': 0},
            ReturnValues="UPDATED_NEW"
        )
        # Convert Decimal to int for JSON serialization
        return int(response['Attributes']['views'])
    except Exception as e:
        print(f"Error updating counter {key_id}: {e}")
        return 0

def get_counter(key_id):
    """Reads a counter from DynamoDB without incrementing."""
    try:
        response = counter_table.get_item(Key={'id': key_id})
        # Handle case where item doesn't exist yet
        val = response.get('Item', {}).get('views', 0)
        return int(val)
    except Exception as e:
        print(f"Error reading counter {key_id}: {e}")
        return 0

def cors_headers():
    return {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
    }