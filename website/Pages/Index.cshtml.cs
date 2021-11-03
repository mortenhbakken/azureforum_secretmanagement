using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

namespace azureforum_secretmanagement.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly IConfiguration _config;
        public string Secret { get; set; }     

        public IndexModel(ILogger<IndexModel> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;
        }

        public void OnGet()
        {
            var keyVaultName = _config["KeyVaultName"];
            var kvUri = "https://" + keyVaultName + ".vault.azure.net";

            var token = new ClientSecretCredential(_config["TenantId"], _config["ClientId"], _config["ClientSecret"]);

            var client = new SecretClient(new Uri(kvUri), token);

            var secret = client.GetSecret("SecretValue");
            this.Secret = secret.Value.Value;
        }
    }
}
