import json
import boto3

def lambda_handler(event, context):

    aws_account_id = context.invoked_function_arn.split(":")[4]

    print(aws_account_id)
    
    region = context.invoked_function_arn.split(":")[3]
    
    print(region)
    
    client = boto3.client('ec2')
    id=event['detail']['responseElements']['instancesSet']['items'][0]['instanceId']
    
    print(id)
    response = client.describe_instances(
        InstanceIds=[
            id,
        ],
    )
    
    
    
    list_tags=response['Reservations'][0]['Instances'][0]['Tags']
    
    
    for x in range(len(list_tags)): 
        if list_tags[x]['Key'] == 'threshold' :
        	threshold=list_tags[x]['Value']
        if list_tags[x]['Key'] == 'owner' :
            owner=list_tags[x]['Value']
    
    
    print(threshold)
    print(owner)
    
       
    
    
    client2 = boto3.client('cloudwatch')
    
    
    response = client2.put_metric_alarm(
        AlarmName=id+'_CPU_Alarm',
        AlarmDescription='string',
        ActionsEnabled=True,
        AlarmActions=[
            'arn:aws:sns:'+ region + ':' + aws_account_id + ':'+ owner
        ],
        MetricName='CPUUtilization',
        Namespace='AWS/EC2',
        Statistic='Average',
        Dimensions=[
            {
                'Name': 'InstanceId',
                'Value': id
            },
        ],
        Period=300,
        EvaluationPeriods=1,
        DatapointsToAlarm=1,
        Threshold=int(threshold),
        ComparisonOperator='GreaterThanOrEqualToThreshold',
        TreatMissingData='missing',
        Tags=[
            {
                'Key': 'from',
                'Value': 'code'
            },
        ],
    )



    

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }


