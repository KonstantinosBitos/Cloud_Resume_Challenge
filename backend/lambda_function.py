import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    
    response = table.update_item(
        Key={
            'id': '1'
        },

        # Use '#v' instead of 'views' because 'views' is a reserved word
        UpdateExpression='SET #v = #v + :val',
        
        # Tell DynamoDB that '#v' means 'views'
        ExpressionAttributeNames={
            '#v': 'views'
        },
        
        ExpressionAttributeValues={
            ':val': 1
        },
        ReturnValues="UPDATED_NEW"
    )
    
    new_count = int(response['Attributes']['views'])
    
    views = response.get('Attributes', {}).get('views', 0)
    if isinstance(views, Decimal):
        views = int(views)
    
    #Return the value
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps({'count': views})
    }