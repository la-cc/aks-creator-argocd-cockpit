from schema import Schema, Optional

config_schema = Schema({

    Optional("azure_backend"): {
        Optional("enable"): bool,
        Optional("resource_group_name_backend"): str,
        Optional("storage_account_name"): str,

    },

    "clusters": [
        {
            "name": str,
            "stage": str,
            Optional("admin_list", default=[]): list,
            Optional("azure_public_dns"): {
                Optional("enable", default=False): bool,
                Optional("azure_cloud_zone"): str,
            },
            # default node-pool
            Optional("node_pool_count", default=3): int,
            Optional("vm_size", default="Standard_B4ms"): str,
            Optional("kubernetes_version", default="1.24.9"): str,
            Optional("orchestrator_version", default="1.24.9"): str,
            # additional node-pools
            Optional("node_pools"): {
                Optional("enable_node_pools"): bool,
                Optional("pool"): [
                    {
                        Optional("name"): str,
                        Optional("min_count"): int,
                        Optional("max_count"): int,
                        Optional("node_count"): int,
                    }
                ]
            },
            Optional("argocd"): {
                Optional("oidc_config"): {
                    Optional("enable"): bool,
                    Optional("url"): str,
                    Optional("tenantID"): str,
                    Optional("clientID"): str,
                    Optional("rbac_role_group_mapping"): str,
                },

                Optional("ingress"): {
                    Optional("enable", default=False): bool,
                    Optional("host"): str,
                    Optional("issuer"): str,
                },
                Optional("externalDNS"): {
                    Optional("enable", default=False): bool,
                    Optional("resource_group"): str,
                    Optional("tenantID"): str,
                    Optional("subscriptionID"): str,
                    Optional("domain_filters"): list,
                    Optional("txtOwnerId"): str
                },

                Optional("security"): {
                    Optional("enable", default=False): bool,
                    Optional("clusterIssuerDNS"): {
                        Optional("e_mail"): str,
                        Optional("subscriptionID"): str,
                        Optional("resourceGroupName"): str,
                        Optional("hostedZoneName"): str
                    },
                    Optional("clusterIssuerHTTP"): {
                        Optional("e_mail"): str
                    }
                },

                Optional("ksc"): {
                    Optional("enable", default=False): bool,
                    Optional("url"): str,
                    Optional("pat"): str,
                    Optional("organization"): str
                }
            }
        }
    ],

    Optional("azure_devops_pipeline"): {
        Optional("enable"): bool,
        Optional("library_group"): str,

    }
})
