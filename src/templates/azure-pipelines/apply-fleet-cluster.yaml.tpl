{% raw %}
parameters:
  - name: clusters
    type: object
    default: {}

steps:
  - ${{ each cluster in parameters.clusters }}:
      - task: Bash@3
        displayName: Start Apply Fleet Clusters - ${{ cluster.name }}
        inputs:
          script: |
            echo "######### Start Apply Fleet Clusters for ${{ cluster.name }} ############"
          targetType: inline
      - task: Bash@3
        displayName: Login (Fleet) vs azure kubernetes cluster for ${{ cluster.name }}
        inputs:
          script: |
            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID >> /dev/null 2>&1
            az account set --subscription $ARM_SUBSCRIPTION_ID

            #Cleanup
            if [ -f cluster.csv ]; then
              rm cluster.csv
            fi

            az aks list | jq '.[].name' -r | grep -v "aks-${{ cluster.repositoryName }}-development"| grep -v "aks-${{ cluster.repositoryName }}-development" | grep -v "aks-${{ cluster.repositoryName }}-production" | grep -v "excelsior" | grep -i "${{ cluster.environment }}" | sed 's/aks-//' > cluster.csv

            cat cluster.csv | while read -r item;
            do
              cluster=$(echo $item | awk -F' ' '{print $1}')
              az aks get-credentials --resource-group rg-$cluster-platform --name aks-$cluster || true
            done
          targetType: inline
        env:
          ARM_CLIENT_ID: $(ARM_CLIENT_ID)
          ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          ARM_TENANT_ID: $(ARM_TENANT_ID)
          ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: Convert (Fleet) kubeconfig to spn (Kubelogin)
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
        displayName: Establish Connection to Fleet
        inputs:
          script: |
            kubectl config use-context aks-${{ cluster.name }}
            argocd login $(kubectl get ingress argocd-server-ingress -n argocd --output=jsonpath='{.spec.rules[0].host}') --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure --grpc-web

            cat cluster.csv | while read -r item;
            do
              cluster=$(echo $item | awk -F' ' '{print $1}')
              argocd cluster add aks-$cluster --label env=${{ cluster.environment }} --upsert --yes
            done
          targetType: inline
        env:
          AAD_SERVICE_PRINCIPAL_CLIENT_ID: $(ARM_CLIENT_ID)
          AAD_SERVICE_PRINCIPAL_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: End Apply Fleet Clusters - ${{ cluster.name }}
        inputs:
          script: |
            echo "######### End Apply Fleet Clusters for ${{ cluster.name }} ############"
          targetType: inline
{% endraw %}