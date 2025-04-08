const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "friendzone": {
                    "endpointType": "REST",
                    "endpoint": "https://hx5lc8653a.execute-api.us-east-1.amazonaws.com/dev",
                    "region": "us-east-1",
                    "authorizationType": "AWS_IAM"
                },
                "friendzonegraphql": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://a35oicbrirauvdio5aszncqnui.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-4g4yshhdu5grdipswwcphrnzlm"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:4941b9c7-72da-4f3a-b65c-989af6e22f02",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_AbkGV6CEY",
                        "AppClientId": "4bq9tkpce2pjfn3v8udmmp77ee",
                        "Region": "us-east-1"
                    }
                },
                "GoogleSignIn": {
                    "Permissions": "email,profile,openid",
                    "ClientId-WebApp": "8909799113-40miat6mesqct653t62h0736q2j16gvr.apps.googleusercontent.com"
                },
                "FacebookSignIn": {
                    "AppId": "623672113961525",
                    "Permissions": "public_profile"
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "friendzone4fa5dac1-4fa5dac1-dev.auth.us-east-1.amazoncognito.com",
                            "AppClientId": "4bq9tkpce2pjfn3v8udmmp77ee",
                            "SignInRedirectURI": "myapp://",
                            "SignOutRedirectURI": "myapp://",
                            "Scopes": [
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [
                            "FACEBOOK",
                            "GOOGLE"
                        ],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL",
                            "NAME"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "DynamoDBObjectMapper": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "friendzonebucketee3be-dev",
                        "Region": "us-east-1"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://a35oicbrirauvdio5aszncqnui.appsync-api.us-east-1.amazonaws.com/graphql",
                        "Region": "us-east-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-4g4yshhdu5grdipswwcphrnzlm",
                        "ClientDatabasePrefix": "friendzonegraphql_API_KEY"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsDynamoDbStoragePlugin": {
                "partitionKeyName": "userId",
                "region": "us-east-1",
                "arn": "arn:aws:dynamodb:us-east-1:940482446120:table/FriendZoneUsers-dev",
                "streamArn": "arn:aws:dynamodb:us-east-1:940482446120:table/FriendZoneUsers-dev/stream/2025-02-22T22:53:31.779",
                "partitionKeyType": "S",
                "name": "FriendZoneUsers-dev"
            },
            "awsS3StoragePlugin": {
                "bucket": "friendzonebucketee3be-dev",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';
