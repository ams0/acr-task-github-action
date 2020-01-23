#!/usr/bin/env bash
set -e

INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
INPUT_TAG=${INPUT_TAG:-$GITHUB_SHA}
INPUT_REPOSITORY=${INPUT_REPOSITORY}
INPUT_BRANCH=${INPUT_BRANCH:-master}

echo "Building Docker image ${repository}/${INPUT_IMAGE}:${INPUT_TAG} from ${GITHUB_REPOSITORY} on ${INPUT_BRANCH} and using context ${INPUT_FOLDER} ; and pushing it to ${registry} Azure Container Registry"
env

az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}
#az login --service-principal -u $INPUT_SERVICE_PRINCIPAL -p $service_principal_password --tenant $tenant

az acr build -r ${registry} -f ${INPUT_DOCKERFILE} -t ${INPUT_REPOSITORY}/${INPUT_IMAGE}:${INPUT_TAG} ${INPUT_GITHUB_REPOSITORY}#${INPUT_BRANCH}:${INPUT_FOLDER}
