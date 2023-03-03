import boto3

def handler(event,context):
    ssm = boto3.client('ssm')
    subnet_a = ssm.get_parameter(Name='ecs_subnet_a', WithDecryption=False)
    subnet_b = ssm.get_parameter(Name='ecs_subnet_b', WithDecryption=False)

    client = boto3.client('ecs')
    response = client.run_task(
    cluster='dev-to', # name of the cluster
    launchType = 'FARGATE',
    taskDefinition='dev-to', # replace with your task definition name and revision
    count = 1,
    platformVersion='LATEST',
    networkConfiguration={
        'awsvpcConfiguration': {
            'subnets': [
                subnet_a['Parameter']['Value'], # replace with your public subnet or a private with NAT
                subnet_b['Parameter']['Value'] # Second is optional, but good idea to have two
            ],
            'assignPublicIp': 'ENABLED'
        }
    },
    overrides={
        "containerOverrides": [{
            "name": "site",
            "environment": [
                {
                    "name": "override",
                    "value": "value"
                }
            ]
        }]
        
    }
    )
    return str(response)

if __name__ == '__main__':
    handler(None, None)