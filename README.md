# ACR Build Task Github action

A Github action to use Azure Container Registry to build and store docker containers.

## Parameters:


`dockerfile` [OPTIONAL]

Path to the Dockerfile relative to `folder`; defaults to `./Dockerfile`

`folder` [OPTIONAL]

Build context for Docker; default to the root of the git repository

`repository` [MANDATORY]

The repository on the Azure Container Registry to hold the `image`

`image` [MANDATORY]

Docker image name

`tag` [OPTIONAL]

Docker image tag; defaults to the first 8 charcater of the commit SHA

`git_access_token` [OPTIONAL]

The Github access token for private repositories

`registry` [MANDATORY]

The Azure Container Registry name

`tenant` [MANDATORY]

The Azure tenant where the ACR is located

`service_principal`

`service_principal_password`

The Service Principal credentials (see below)

`build_args` [OPTIONAL]

Build arguments to be passed to the Docker build process

## Example usage

Create an SP with Contributor access to the Azure Container Registry

```bash
az ad sp create-for-rbac -n "acrtask0" --skip-assignment
az role assignment create --assignee <spID> --scope <resourceID of the ACR> --role "Contributor"
```

In your repository, create the following secrets (or set them in clear in the workflow definition):

- service_principal
- service_principal_password
- tenant
- registry
- repository
- (optional, for accessing private repositories) git_access_token 

In `.github/workflows` create a workflow file like the following:

```yaml
name: build_poi
on:
  push:
    paths:
      - "src/poi/**"
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: ACR build
        id: acr
        uses: ams0/acr-task-github-action@v1
        with:
          service_principal: ${{ secrets.service_principal }}
          service_principal_password: ${{ secrets.service_principal_password }}
          tenant: ${{ secrets.tenant }}
          registry: ${{ secrets.registry }}
          repository: ${{ secrets.repository }}
          image: poi
          git_access_token: ${{ secrets.git_access_token }}
          folder: src/poi
          dockerfile: ../../dockerfiles/Dockerfile_3
```

 You can find the example [here](https://github.com/ams0/openhack-containers). The workflow will be triggered when something is pushed to `src/poi` folder.

## Arguments

- `service_principal` the SP for logging into the ACR (mandatory)  
- `service_principal_password` the SP password (mandatory)
- `tenant` SP tenant (mandatory)
- `registry` the Azure container registry, minus the `.azurecr.io` part (mandatory)
- `repository` remote repository (mandatory)
- `branch` git branch (optional)
- `git_access_token` git access token (optional)
- `image` the docker image name (optional)
- `folder` the context for the docker build (optional)
- `dockerfile` the location of the Dockerfile relative to the context (optional)
- `tag` the docker image tag, defaults to the short git SHA (optional)
- `build_args` (optional) the docker build args in JSON format (`[{"MY_ARG": "this_is_a_test"}]`)
