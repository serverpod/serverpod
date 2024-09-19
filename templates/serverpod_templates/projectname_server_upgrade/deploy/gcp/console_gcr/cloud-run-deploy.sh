#!/bin/bash

# These are the variables that need to be set to be able to deploy to cloud run.
# You can find the values in the Google Cloud Console.
DATABASE_INSTANCE_CONNECTION_NAME="<DATABASE CONNECTION NAME>"
SERVICE_ACCOUNT="<SERVICE ACCOUNT EMAIL>"

# Optionally configure the region and runmode (staging is also viable).
REGION="us-central1"
RUNMODE="production"


# Check that we are running the script from the correct directory.
if [ ! -f config/production.yaml ]; then
    echo "Run this script from the root of your server directory (e.g., mypod/mypod_server)."
    exit 1
fi


# Deploy the API server.
echo "Deploying API server..."

gcloud run deploy serverpod-api \
  --source=. \
  --region=$REGION \
  --platform=managed \
  --service-account=$SERVICE_ACCOUNT \
  --port=8080 \
  --set-cloudsql-instances=$DATABASE_INSTANCE_CONNECTION_NAME \
  --execution-environment=gen2 \
  --set-env-vars="runmode=$RUNMODE" \
  --set-env-vars="role=serverless" \
  --allow-unauthenticated


# Deploy the Insights server. This is used by the Serverpod Insights app. It
# can provide run time information and logs from the API server.
echo "Deploying Insights server..."

gcloud run deploy serverpod-insights \
  --source=. \
  --region=$REGION \
  --platform=managed \
  --service-account=$SERVICE_ACCOUNT \
  --port=8081 \
  --set-cloudsql-instances=$DATABASE_INSTANCE_CONNECTION_NAME \
  --execution-environment=gen2 \
  --set-env-vars="runmode=$RUNMODE" \
  --set-env-vars="role=serverless" \
  --allow-unauthenticated
