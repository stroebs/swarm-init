# swarm-init
A Docker Swarm init container, based on the official docker4x/swarm-init, for use in a non-AWS environment.

Quite simply put, I needed a production-ready container which would initialise my Docker Swarm, in the same way that the Docker for AWS method uses. The storage backend for this still utilises DynamoDB to keep track of the primary manager, which may or may not be of use to you.

## Dockerfile
The Dockerfile is quite simple. I could've made it smaller using a multi-stage build or converting the entire thing to Python and using pip packages instead of including the entire Docker binary. I decided not to do that in order to maintain simplicity so you know exactly what the script is doing, while using official versioned binaries.

## Usage
You can use the automated Docker Hub build associated with this repository:

`docker run --log-driver=json-file --restart=no -d -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e NODE_IP=$NODE_IP -e DYNAMODB_TABLE=$DYNAMODB_TABLE -e NODE_TYPE=$NODE_TYPE -e REGION=$AWS_REGION -v /var/run/docker.sock:/var/run/docker.sock -v /var/log:/var/log stroebs/swarm-init:18.06.1-ce`
- `NODE_IP`: Specified manually, using whichever calling script is setting this up. There is no metadata service in the CaaS I am using.
- `NODE_TYPE`: Either 'manager' or 'worker'
- `DYNAMODB_TABLE`: The Dynamo DB table name you will use to store your primary manager information
- `REGION`: The AWS region for your DynamoDB table
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID (Must have access to write to DynamoDB)
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key (Must have access to write to DynamoDB)

You can build the image yourself:
`docker build -t swarm-init .`

NOTE: This script still relies on a metadata service avialable at http://$MANAGER_IP:9024 - which I am still busy writing, contained at https://github.com/stroebs/swarm-meta
