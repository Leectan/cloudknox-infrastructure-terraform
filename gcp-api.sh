#lee.tan
#!/usr/bin/env bash

# Stop immediately if something goes wrong
set -euo pipefail

# Validate the user would like to proceed
echo
echo "There will be a few APIs enabled in your Google Cloud account:"
read -p "Would you like to proceed? [y/n]: " -n 1 -r
echo
# Require a "Y" or "y" to proceed. Otherwise abort.
if [[ ! "$REPLY" =~ ^[Yy]$ ]]
then
    # Do not continue. Do not enable the APIs.
    echo "Exiting without making changes."
    exit 1
fi

#Set Project ID
PROJECT_ID="$(gcloud config get-value project)"

if [[-z "$ACCOUNT_ID" ]]; then
    echo "please export ACCOUNT_ID value as environment variable."
    exit 1
fi

#Enable Billing Account on the new project
gcloud beta billing projects link $(gcloud config get-value project) --billing-account=$ACCOUNT_ID


# Enable Compute Engine, Kubernetes Engine, and Container Builder
echo "Enabling the APIs"
gcloud services enable \
admin.googleapis.com \
cloudresourcemanager.googleapis.com \
cloudapis.googleapis.com \
compute.googleapis.com \
iam.googleapis.com \
logging.googleapis.com \
stackdriver.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
appengine.googleapis.com \
bigquery-json.googleapis.com \
bigtable.googleapis.com \
bigtableadmin.googleapis.com \
cloudbuild.googleapis.com \
clouddebugger.googleapis.com \
cloudtrace.googleapis.com \
container.googleapis.com \
containerregistry.googleapis.com \
dataproc.googleapis.com \
datastore.googleapis.com

gcloud services enable \
deploymentmanager.googleapis.com \
ml.googleapis.com \
monitoring.googleapis.com \
oslogin.googleapis.com \
pubsub.googleapis.com \
replicapool.googleapis.com \
replicapoolupdater.googleapis.com \
resourceviews.googleapis.com \
servicemanagement.googleapis.com \
spanner.googleapis.com \
sql-component.googleapis.com \
sqladmin.googleapis.com \

