# acr-task-github-action
A Github action to use Azure Container Registry to build and store docker containers


Create an SP with Contributor access to the Azure Container Registry
```
az ad sp create-for-rbac -n "acrtask0" --skip-assignment
az role assignment create --assignee <spID> --scope <resourceID of the ACR> --role "Contributor"
```



https://thorsten-hans.com/azure-container-registry-unleashed-webhooks