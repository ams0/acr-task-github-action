#!/usr/bin/env bash
set -e

INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
INPUT_TAG=${INPUT_TAG:-${GITHUB_SHA::8}}
IMAGE_PART=""

if [ "$INPUT_IMAGE" != "" ]; then
        IMAGE_PART="/${INPUT_IMAGE}"
fi

echo "Building Docker image ${INPUT_REPOSITORY}${IMAGE_PART}:${INPUT_TAG} from ${GITHUB_REPOSITORY} on ${INPUT_BRANCH} and using context ${INPUT_FOLDER} ; and pushing it to ${INPUT_REGISTRY} Azure Container Registry"
az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}
az acr build -r ${INPUT_REGISTRY} -f ${INPUT_DOCKERFILE} -t ${INPUT_REPOSITORY}${IMAGE_PART}:${INPUT_TAG} https://github.com/${GITHUB_REPOSITORY}.git#${INPUT_BRANCH}:${INPUT_FOLDER}