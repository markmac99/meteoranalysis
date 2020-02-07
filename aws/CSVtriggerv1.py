import boto3
import botocore
import uuid

def lambda_handler(event, context):

    s3 = boto3.resource('s3')

    record = event['Records'][0]

    s3bucket = record['s3']['bucket']['name']
    s3object = record['s3']['object']['key']
    target = 'arch-analysis'

    x=s3object.find('M20')
    
    if x == -1 :
        # its not a standard ufoa file, check if its an rms file
        #print ('its not a ufoa file')
        x = s3object.find('UK')
        if x == -1 :
            # yep not interested
            return 0
        #okay, create the right format output
        x = s3object.find('_20')+1
        y=x+4
        yr=s3object[x:y]
        outf='P_' + yr + '-unified.csv'
        #print(yr)
    else:
        #print('its a ufoa file')
        x=x+1    
        y=x+4
        yr=s3object[x:y]
        outf='M_' + yr + '-unified.csv'
    curr = '/tmp/' + str(uuid.uuid4().hex)
    dta = '/tmp/' + str(uuid.uuid4().hex)
    
    try:
        resp = s3.meta.client.get_object(Bucket=target, Key=outf)
    except botocore.exceptions.ClientError as e:
        # The object does not exist.
        src={'Bucket' : s3bucket, 'Key': s3object}
        s3.meta.client.copy_object(Bucket=target, Key=outf, CopySource=src)
        #s3.meta.client.upload_file('/dev/null', target, outf)
        #s3.meta.client.download_file(target, outf, curr) 
    else:
        s3.meta.client.download_file(target, outf,curr) 
        s3.meta.client.download_file(s3bucket, s3object,dta) 
        linelist = [line.rstrip('\n') for line in open(dta,'r')]
        uniflist = [line.rstrip('\n') for line in open(curr,'r')]
        newlist = uniflist[0:1] + sorted(set(uniflist[1:] + linelist[1:]))
        with open (curr, 'w') as fout:
            fout.write('\n'.join(newlist))
            
        s3.meta.client.upload_file(curr, target, outf)
    return 0