# AKS Creator

This tool image allows you to create and manage the configuration files of a AKS Kubernetes repository.

## Getting started

In order to be able to use this image, it must be started in the desired AKS Cluster repository using Docker or Podman.
Furthermore, the repository directory must be mounted in the container.
To avoid permission errors, it is recommended to do this with the permissions of the executing user.

### Igor

We will use the `igor`.
The tool opens a shell in your favorite docker container mounting your current workspace into the container.

The following steps are executed:

- Start the image
- Mount necessary directories
- Set permissions
- Clean up

To install `igor` just download the `igor.sh` and store it in your `$PATH` like this:

    sudo curl https://raw.githubusercontent.com/la-cc/igor/main/igor.sh -o /usr/local/bin/igor
    sudo chmod +x /usr/local/bin/igor

#### Configure igor

Running `igor` without configuration will launch a busybox image. In order to use the tool with the AKS Creator image,
a configuration file is required.

> **_NOTE:_** You can get the recent tag from [la-cc/aks-creator-argocd-cockpit](https://github.com/la-cc/aks-creator-argocd-cockpit/tags)

Open the file `.igor.sh` in your preferred editor and use the following settings to configure `igor`:

    # select docker image
    IGOR_DOCKER_IMAGE=ghcr.io/la-cc/aks-creator-core:0.0.2
    IGOR_DOCKER_COMMAND=                                  # run this command inside the docker container
    IGOR_DOCKER_PULL=0                                    # force pulling the image before starting the container (0/1)
    IGOR_DOCKER_RM=1                                      # remove container on exit (0/1)
    IGOR_DOCKER_TTY=1                                     # open an interactive tty (0/1)
    IGOR_DOCKER_USER=$(id -u)                             # run commands inside the container with this user
    IGOR_DOCKER_GROUP=$(id -g)                            # run commands inside the container with this group
    IGOR_DOCKER_ARGS=''                                   # default arguments to docker run
    IGOR_PORTS=''                                         # space separated list of ports to expose
    IGOR_MOUNT_PASSWD=1                                   # mount /etc/passwd inside the container (0/1)
    IGOR_MOUNT_GROUP=1                                    # mount /etc/group inside the container (0/1)
    IGOR_MOUNTS_RO="${HOME}/.azure"                       # space separated list of volumes to mount read only
    IGOR_MOUNTS_RW=''                                     # space separated list of volumes to mount read write
    IGOR_WORKDIR=${PWD}                                   # use this workdir inside the container
    IGOR_WORKDIR_MODE=rw                                  # mount the workdir with this mode (ro/rw)
    IGOR_ENV=''                                           # space separated list of environment variables set inside the container

### Workflow

The following workflow is recommended as part of a aks cluster creation.

| No.                      | Step                                                                          | required | Tool                           |
| ------------------------ | ----------------------------------------------------------------------------- | -------- | ------------------------------ |
| [0](#ConfigAzureBackend) | Allow you configure the azure backend to save the remote state for terraform. | no       | `config-azure-backend`         |
| [1](#InitConfig)         | Initialize empty configuration file.                                          | yes      | `config-init`                  |
| [2](#FillMissing)        | Fill missing fields in configuration file.                                    | yes      | -                              |
| [3](#TemplateConfig)     | Template the whole aks platform folder structure.                             | yes      | `config-template`              |
| [4](#Terraform)          | Create the AKS Cluster with needed context.                                   | yes      | `terrform` (version >= 1.3.0") |

### <a id="ConfigAzureBackend"></a>0. Create a Azure Backend for Terraform State (Optional) `config.yaml`

**Requirements**:

- Azure Active Directory Access
- Azure Subscription Access

The easiest way is to fill the file `.backend.env` with the necessary values.

Then execute the script (from inside the aks-creator-core container):

    config-azure-backend

You can also start the script with interactive mode:

    config-azure-backend -i or config-azure-backend --interactive

### <a id="InitConfig"></a>1. Initialize empty configuration file

**Requirements**: none

Create an empty `config.yaml`.
This already contains the necessary structure and placeholders for the values, as required in the following step.
To do so simply execute the script (from inside the aks-creator-core container):

    config-init

You will get a `config.yaml` that can be filled by you.

### <a id="FillMissing"></a>2. Fill missing fields in `config.yaml`

**Requirements**:

- `config.yaml` of [1. 1. Get configuration file config.yaml](#GetConfig)

You can get more information from [00. Configuration Options for `config.yaml`](#ConfigOptions)

### <a id="TemplateConfig"></a>3. Template the AKS folder structure from `config.yaml`

**Requirements**:

- `config.yaml` of [1. 1. Get configuration file config.yaml](#GetConfig)

To do so simply execute the script (from inside the aks-creator-core container):

    config-template

### <a id="Terraform"></a>4. Terraform Apply

**Requirements**:

- Azure Active Directory Access
- Azure Subscription Access

### 4.1 Terraform Apply + Azure Backend

If go through the step [0. Create a Azure Backend for Terraform State (Optional)](#ConfigAzureBackend) then you need to execute the following commands (from inside the aks-creator-core container or local terraform binary):

    terraform init
    terraform select workspace <STAGE>
    terraform plan -var-file=env/<STAGE>/terraform.tfvars

If the plan is fine for you, then apply it with:

    terraform apply -var-file=env/<STAGE>/terraform.tfvars -auto-approve

### 4.2 Terraform Apply + Local Backend

If you don't create azure backend then execute the following commands (from inside the aks-creator-core container or local terraform binary):

    terraform init
    #terraform version < 1.4.*
    terraform workspace new <STAGE>
    #terraform version  >= 1.4.*
    terraform workspace select -or-create <STAGE>
    terraform plan -var-file=env/<STAGE>/terraform.tfvars

If the plan is fine for you, then apply it with:

    terraform apply -var-file=env/<STAGE>/terraform.tfvars -auto-approve

## <a id="ConfigOptions"></a>00. Configuration Options for `config.yaml`

The following examples show the possible configuration of the templating. The used module itself can be further adjusted or overwritten.

### Minimum necessary configuration

```
---
# Azure Backend for Terraform related data
azure_backend: {}

# Azure Devops Pipeline related data
azure_devops_pipeline: {}

# Azure Kubernetes Cluster related data
clusters:
  - name: excelsior-cloud
    stage: development
    admin_list: []
    azure_public_dns: {}
    node_pools: {}
    # Argo CD Cockpit related data
    argocd:
      oidc_config: {}
      ingress: {}
      externalDNS: {}
      security:
        clusterIssuerDNS: {}
        clusterIssuerHTTP: {}
      ksc: {}
```

### Maximum possible configuration:

```
---
# Azure Backend for Terraform related data
azure_backend:
  enable: true
  resource_group_name_backend: <>
  storage_account_name: <>

# Azure Devops Pipeline related data
azure_devops_pipeline:
  enable: true
  library_group: <>

# Azure Kubernetes Cluster and Argo CD related data
clusters:
  - name: excelsior-cloud
    stage: development
    admin_list:
      [
        "3987rzhdia3d32d2", "sid4934932-2324342"
      ]
    azure_public_dns:
      enable: true
      azure_cloud_zone: <>
    node_pools: {}
    # Argo CD Cockpit related data
    argocd:
      oidc_config:
        enable: true
        url: https://argocd.<>/
        tenantID: <>
        clientID: <>
        rbac_role_group_mapping: <>
      ingress:
        host: argocd.<>
        issuer: letsencrypt-dns
      externalDNS:
        enable: true
        resource_group: <>
        tenantID: <>
        subscriptionID: <>
        domain_filters:
          - <>
        txtOwnerId: <>
      security:
        enable: true
        clusterIssuerDNS:
          e_mail: <>
          subscriptionID: <>
          resourceGroupName: <>
          hostedZoneName: <>
        clusterIssuerHTTP:
          e_mail: <>
      ksc:
        enable: true
        url: <>
        pat: <>
        organization: <>
```
