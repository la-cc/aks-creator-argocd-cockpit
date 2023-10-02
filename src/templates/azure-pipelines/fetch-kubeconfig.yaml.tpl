{% raw %}
parameters:
  - name: clusters
    type: object
    default: {}

steps:
  - ${{ each cluster in parameters.clusters }}:
      - task: Bash@3
        displayName: Start Fetch Kubeconfig - ${{ cluster.name }}
        inputs:
          script: |
            echo "######### Start Fetch Kubeconfig for ${{ cluster.name }} ############"
          targetType: inline
      - task: Bash@3
        displayName: Login (Cockpit) vs azure kubernetes cluster
        inputs:
          script: |
            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID >> /dev/null 2>&1
            az account set --subscription $ARM_SUBSCRIPTION_ID
            az aks get-credentials --resource-group rg-${{ cluster.name }}-platform --name aks-${{ cluster.name }}
          targetType: inline
        env:
          ARM_CLIENT_ID: $(ARM_CLIENT_ID)
          ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          ARM_TENANT_ID: $(ARM_TENANT_ID)
          ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: Convert (Cockpit) kubeconfig to spn (Kubelogin)
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
        displayName: End Fetch Kubeconfig - ${{ cluster.name }}
        inputs:
          script: |
            echo "######### End Fetch Kubeconfig for ${{ cluster.name }} ############"
          targetType: inline
{% endraw %}