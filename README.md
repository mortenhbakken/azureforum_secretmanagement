# Azure Forum Secret Management demo
You can use the code and pipeline provided in this GitHub repository to replicate the demo that was done in the Azure Forum on 09.11.21
It is organized into 3 branches showcasing the 3 different approaches demoed as follows:
- **secret_as_configuration** - Secret is inserted into the application configuration in the pipeline
- **secret_loaded_from_kv** - Secret is written to a key vault, the application fetches the secret via SDK authenticating with a Service Principal
- **secret_loaded_from_kv_with_mi** - Secret is written to a key vault and a key vault reference is written to the application configuration file. The web app is set up with a Managed Identity that has permissions to read the secret from key vault

There are a few common prerequisites for all the scenarios:
- An active Azure subscription
- A Service Principal with *owner* rights in the subscription, configured as a Secret in the GitHub repository ([guide](https://github.com/marketplace/actions/azure-login#configure-a-service-principal-with-a-secret))
- A secret value that you want to deploy into Azure. Store this as a GitHub Secret under the name *SECRET_VALUE*
- Create globally unique name(s) for the Web App(s) and Key Vault(s) to be deployed. These are parameterized in the bicep file, can be overriden by hand in the GitHub Action file (.github/workflows/CIflow.yml)
- .Net 5 SDK

For the **secret_loaded_from_kv** there is one additional prerequisite:
- A Service Principal that the web app will programmatically use to authenticate to Key Vault. Create it with Azure CLI or in the Portal and store the following secrets in GitHub Secrets:
    - WEBSITEID_CLIENTID
    - WEBSITEID_CLIENTSECRET
    - WEBSITEID_PRINCIPALID
    - WEBSITEID_TENANTID   
