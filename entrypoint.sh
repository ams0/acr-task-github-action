#!/usr/bin/env bash
set -e

INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
INPUT_TAG=${INPUT_TAG:-$GITHUB_SHA}

echo "Building Docker image ${INPUT_REPOSITORY}/${INPUT_IMAGE}:${INPUT_TAG} from ${GITHUB_REPOSITORY} on ${INPUT_BRANCH} and using context ${INPUT_FOLDER} ; and pushing it to ${INPUT_REGISTRY} Azure Container Registry"

az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}

az acr build -r ${INPUT_REGISTRY} -f ${INPUT_DOCKERFILE} -t ${INPUT_REPOSITORY}/${INPUT_IMAGE}:${INPUT_TAG} ${GITHUB_REPOSITORY}#${INPUT_BRANCH}:${INPUT_FOLDER}
