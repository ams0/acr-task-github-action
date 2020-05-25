# ACR Build Task Github action

A Github action to use Azure Container Registry to build and store docker containers

## Example usage

Create an SP with Contributor access to the Azure Container Registry

```bash
az ad sp create-for-rbac -n "acrtask0" --skip-assignment
az role assignment create --assignee <spID> --scope <resourceID of the ACR> --role "Contributor"
```

In your repository, create the following secrets:

- service_principal
- service_principal_password
- tenant
- registry
- repository

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
- `image` the docker image name (optional)
- `folder` the context for the docker build (optional)
- `dockerfile` the location of the Dockerfile relative to the context (optional)
- `tag` the docker image tag, defaults to the short git SHA (optional)
