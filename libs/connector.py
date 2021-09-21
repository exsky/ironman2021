import boto3
from botocore.config import Config


class Connector:

    def __init__(self, srv_name):
        # If you prefer using specific region rather than ~/.aws/credentials
        self.config = Config(
            region_name='ap-northeast-3',
            signature_version='v4',
            retries={
                'max_attempts': 10,
                'mode': 'standard'
            }
        )
        self.srv_name = srv_name
        # The profile_name is 'default' in ~/.aws/credentials
        self.session = boto3.Session(profile_name='default')
        self.client = self.session.client(srv_name)
        # self.client = self.session.client(srv_name, config=self.config)

    def connect_aws_service(self):
        return self.client
