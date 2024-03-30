"arn:aws:lambda:eu-west-2:637423623136:function:invoked-lfunc"
import json
import uuid

def lambda_handler(event, context):
    """
    A Lambda function that generates a random ID and returns it.

    Parameters:
        event: The event that triggered the Lambda function.
        context: The context of the Lambda function invocation.

    Returns:
        A dictionary containing the CustomerId, Success, and TransactionId.
    """

    # 1. Read off the input arguments
    customer_id = event['CustomerId']

    # 2. Generate a random id
    transaction_id = str(uuid.uuid1())

    # 3. Do some stuff i.e. save to s3, write to database, etc...

    # 4. Format and return response
    return {'CustomerId': customer_id, 'Success': 'true', 'TransactionId': transaction_id}

