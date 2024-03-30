import json
import boto3
import os

client = boto3.client('lambda')

def lambda_handler(event, context):
    inputForInvoker = {'CustomerId': '123', 'Amount': 50 } # This is the input for the invoked function
    
    response = client.invoke(
        FunctionName= os.environ['INVOKED_LAMBDA_ARN'],
        InvocationType='RequestResponse', # Event # RequestResponse = synchronous, Event = asynchronous
        Payload=json.dumps(inputForInvoker) # This is the input for the invoked function transmitted as a JSON string
    )

    responseJson = json.load(response['Payload']) # The response from the invoked function

    print('\n')
    print(responseJson) # Print the response from the invoked function
    print('\n')

