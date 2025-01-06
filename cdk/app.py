# Install library -> pip install aws-cdk-lib constructs
from aws_cdk import (
    aws_s3 as s3,
    aws_lambda as _lambda,
    aws_apigateway as apigw,
    Stack,
    App,
    CfnOutput
)
from constructs import Construct

class MyHelloWorldStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        bucket = s3.Bucket(self, "cdk-bucket",
                           website_index_document="index.html",
                           public_read_access=True,
                           block_public_access=s3.BlockPublicAccess.BLOCK_ACLS)

        my_lambda = _lambda.Function(
            self, "HelloLambda",
            runtime=_lambda.Runtime.PYTHON_3_9,
            handler="lambda-handler.handler",
            code=_lambda.Code.from_asset("lambda")
        )

        api = apigw.RestApi(self, "MyApi")

        hello_resource = api.root.add_resource("hello")
        hello_integration = apigw.LambdaIntegration(my_lambda)
        hello_resource.add_method("GET", hello_integration)

        CfnOutput(self, "WebsiteURL",
                  description="Access your static HTML page from this S3 bucket website endpoint.",
                  value=bucket.bucket_website_url)
        
        my_api_endpoint_output = CfnOutput(self, "ApiEndpoint",
                  description="Invoke the Lambda by sending a GET request to /hello",
                  value=api.url + "hello")

app = App()
MyHelloWorldStack(app, "jch-cdk-stack")
app.synth()