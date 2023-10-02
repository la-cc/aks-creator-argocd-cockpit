from schema import Schema, Optional

config_schema = Schema({


    Optional("azure_tags"): {
        Optional("maintainer", default="Platform Team"): str,
        Optional("owner", default="Platform Team"): str,

    },

    "clusters": [
        {
            "name": str,
            "stage": str,
            Optional("admin_list", default=[]): list,
            Optional("authorized_ip_ranges", default=["0.0.0.0/0"]): list,
            Optional("azure_public_dns"): {

                Optional("azure_cloud_zone"): str,
            },
            Optional("azuread_user"): {
                Optional("name"): str,
                Optional("display_name"): str,
                Optional("mail_nickname"): str,
            },
            Optional("azure_backend"): {
                Optional("resource_group_name_backend"): str,
                Optional("storage_account_name"): str,
                Optional("stage"): str,

            },
            Optional("azure_key_vault"): {
                Optional("name"): str,
                Optional("git_repo_url"): str,
                Optional("service_principal_name"): str,
                Optional("svc_user_pw_name"): str,
                Optional("admin_object_ids"): {

                    Optional("ID"): str,
                    Optional("name"): str,
                }
            },
            # default node-pool
            Optional("node_pool_count", default=3): int,
            Optional("vm_size", default="Standard_B4ms"): str,
            Optional("kubernetes_version", default="1.27.1"): str,
            Optional("orchestrator_version", default="1.27.1"): str,
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
            Optional("argocd_aad_apps"): [
                {
                    Optional("name"): str,
                    Optional("app_owners"): [str],
                    Optional("logout_url"): str,
                    Optional("redirect_uris"): [str],
                    Optional("roles"): [
                        {
                            Optional("name"): str,
                            Optional("id"): str,
                            Optional("object_id"): str
                        }
                    ]
                }
            ],
            Optional("argocd"): {
                Optional("oidc_config"): {
                    Optional("instanceLabelKey", default="orga/appname"): str,
                    Optional("url"): str,
                    Optional("tenantID"): str,
                    Optional("clientID"): str,
                    Optional("rbac_role_group_mapping"): str,
                },

                Optional("ingress"): {
                    Optional("host"): str,
                    Optional("issuer"): str,
                },
                Optional("externalDNS"): {
                    Optional("resource_group"): str,
                    Optional("tenantID"): str,
                    Optional("subscriptionID"): str,
                    Optional("domain_filters"): list,
                    Optional("txtOwnerId"): str
                },
                Optional("externalSecrets"): {
                    Optional("keyVaultURL"): str,
                    Optional("name"): str
                },

                Optional("security"): {
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
                    Optional("url"): str,
                }
            }
        }
    ],

    Optional("azure_devops_pipeline"): {
        Optional("library_group"): str,
    }
})
