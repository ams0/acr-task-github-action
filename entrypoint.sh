#!/usr/bin/env bash
set -e

INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
INPUT_TAG=${INPUT_TAG:-${GITHUB_SHA::8}}

if [ -z "$INPUT_GIT_ACCESS_TOKEN" ]; then
        GIT_ACCESS_TOKEN_FLAG="--git-access-token ${INPUT_GIT_ACCESS_TOKEN}"
fi

echo "Building Docker image ${INPUT_REPOSITORY}${IMAGE_PART}:${INPUT_TAG} from ${GITHUB_REPOSITORY} on ${INPUT_BRANCH} and using context ${INPUT_FOLDER} ; and pushing it to ${INPUT_REGISTRY} Azure Container Registry"
az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}
az acr build $GIT_ACCESS_TOKEN_FLAG -r ${INPUT_REGISTRY} -f ${INPUT_DOCKERFILE} -t ${INPUT_REPOSITORY}/${INPUT_IMAGE}:${INPUT_TAG} https://github.com/${GITHUB_REPOSITORY}.git#${INPUT_BRANCH}:${INPUT_FOLDER}