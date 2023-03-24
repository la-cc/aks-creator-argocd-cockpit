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
            echo "######### Start Fetch Kubeconfig for ${{ cluster.name }} ############"
          targetType: inline
      - task: Bash@3
        displayName: ${{ cluster.name }} - Install kubelogin
        inputs:
          script: |
            echo "######### Intsall kubelogin ############"
            curl -L https://github.com/Azure/kubelogin/releases/download/v0.0.28/kubelogin-linux-amd64.zip \
                -o kubelogin.unzip \
                && unzip kubelogin.unzip \
                && mv bin/linux_amd64/kubelogin /usr/local/bin
          targetType: inline
      - task: Bash@3
        displayName: ${{ cluster.name }} - Install argocd cli
        inputs:
          script: |
            echo "######### Intsall argocd cli ############"
            curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
            sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
            rm argocd-linux-amd64
          targetType: inline
      - task: Bash@3
        displayName: ${{ variables.clusterName }}  Login (Cockpit) vs azure kubernetes cluster
        inputs:
          script: |
            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID >> /dev/null 2>&1
            az account set --subscription $ARM_SUBSCRIPTION_ID
            az aks get-credentials --resource-group rg-${{ cluster.name }} --name aks-${{ cluster.name }}
          targetType: inline
        env:
          ARM_CLIENT_ID: $(ARM_CLIENT_ID)
          ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
          ARM_TENANT_ID: $(ARM_TENANT_ID)
          ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
          KUBECONFIG: ${{ cluster.repositoryName }}/kubeconfig
      - task: Bash@3
        displayName: ${{ variables.clusterName }} Convert (Cockpit) kubeconfig to spn (Kubelogin)
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
        displayName: ${{ cluster.name }} - End
        inputs:
          script: |
            echo "######### End Fetch Kubeconfig for ${{ cluster.name }} ############"
          targetType: inline
{% endraw %}