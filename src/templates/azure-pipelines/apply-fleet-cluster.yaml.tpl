{% raw %}
parameters:
  - name: clusters
    type: object
    default: {}

steps:
  - ${{ each cluster in parameters.clusters }}:
      - task: Bash@3
        displayName: ${{ cluster.name }} - Start
        inputs:
          script: |
            echo "######### Start Apply Fleet Clusters for ${{ cluster.name }} ############"
          targetType: inline
      - task: Bash@3
        displayName: ${{ variables.clusterName }} - Login vs azure kubernetes cluster
        inputs:
          script: |
            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID >> /dev/null 2>&1
            az account set --subscription $ARM_SUBSCRIPTION_ID

            cat argocd/env/${{ cluster.environment }}/clusters/clusters.csv | while read -r item;
            do
              cluster=$(echo $item | awk -F' ' '{print $1}')
              az aks get-credentials --resource-group rg-$cluster --name aks-$cluster
            done
          targetType: inline
        env:
          ARM_CLIENT_ID: $(ARM_CLIENT_ID)
          ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          ARM_TENANT_ID: $(ARM_TENANT_ID)
          ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: ${{ variables.clusterName }} - Convert kubeconfig to spn (Kubelogin)
        inputs:
          script: |
            kubelogin convert-kubeconfig -l spn
          targetType: inline
        env:
          AAD_SERVICE_PRINCIPAL_CLIENT_ID: $(ARM_CLIENT_ID)
          AAD_SERVICE_PRINCIPAL_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          ARM_CLIENT_ID: $(ARM_CLIENT_ID)
          ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: Establish Connection to Fleet - ${{ cluster.name }}
        inputs:
          script: |
            kubectl config use-context aks-${{ cluster.name }}
            argocd login $(kubectl get ingress argocd-server-ingress -n argocd --output=jsonpath='{.spec.rules[0].host}') --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure --grpc-web

            cat argocd/env/${{ cluster.environment }}/clusters/clusters.csv | while read -r item;
            do
              cluster=$(echo $item | awk -F' ' '{print $1}')
              env=$(echo $item | awk -F' ' '{print $2}')
              argocd cluster add aks-$cluster --label $env --upsert
            done
          targetType: inline
        env:
          AAD_SERVICE_PRINCIPAL_CLIENT_ID: $(ARM_CLIENT_ID)
          AAD_SERVICE_PRINCIPAL_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: ${{ cluster.name }} - End
        inputs:
          script: |
            echo "######### End Apply Fleet Clusters for ${{ cluster.name }} ############"
          targetType: inline
{% endraw %}