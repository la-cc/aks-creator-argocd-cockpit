#!/bin/bash

echo "Patch argocd-secret with the app registration secretion to allow sso over oidc from azure"
kubectl -n argocd patch secret argocd-secret --type='json' -p='[{"op" : "replace" ,"path" : "/data/oidc.azure.clientSecret" ,"value" : "<REPLACE_ME_BASE64>"}]'

echo "Restart argocd-server and argocd-dex-server"
kubectl rollout restart deployment argocd-server -n argocd
kubectl rollout restart deployment argocd-dex-server -n argocd
