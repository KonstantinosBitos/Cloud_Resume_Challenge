import json
import boto3
import os
from decimal import Decimal

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        #Update the count (Atomic Increment)
        # 'if_not_exists' initializing the counter if it's missing
        response = table.update_item(
            Key={'id': '1'},
            UpdateExpression='SET #v = if_not_exists(#v, :zero) + :val',
            ExpressionAttributeNames={'#v': 'views'},
            ExpressionAttributeValues={
                ':val': 1,
                ':zero': 0
            },
            ReturnValues="UPDATED_NEW"
        )
        
        # Get the new view count safely
        views = response.get('Attributes', {}).get('views', 0)
        
        if isinstance(views, Decimal):
            views = int(views)

        # Return the response for API Gateway Proxy
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps({'count': views}) 
        }

    except Exception as e:
        print(f"ERROR: {str(e)}") # show up in CloudWatch logs
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps({'error': str(e)})
        }