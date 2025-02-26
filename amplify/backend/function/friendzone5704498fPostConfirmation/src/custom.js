const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");
const client = new DynamoDBClient({ region: "us-east-1" }); // Replace with your AWS region

exports.handler = async (event) => {
  const userId = event.request.userAttributes.sub;
  const name = event.request.userAttributes.name || "User";
  const email = event.request.userAttributes.email;
  const createdAt = new Date().toISOString();

  // Replace "User-xxxxxx" with your actual DynamoDB table name (check Amplify backend)
  const params = {
    TableName: "FriendZoneUsers-dev",
    Item: {
      userId: { S: userId },
      name: { S: name },
      email: { S: email },
      fcmToken: { S: "" }, // Initialize empty
      interests: { L: [] }, // Empty list
      hobbies: { L: [] }, // Empty list
      createdAt: { S: createdAt },
      updatedAt: { S: createdAt },
    },
  };

  try {
    await client.send(new PutItemCommand(params));
    console.log("User profile created in DynamoDB");
  } catch (error) {
    console.error("Error creating user profile:", error);
  }

  return event;
};