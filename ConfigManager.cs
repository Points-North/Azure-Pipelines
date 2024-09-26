using System;
using System.Linq;
using System.Xml.Linq;

namespace ConfigUpdater
{
    public class ConfigManager
    {
        private readonly XDocument _config;
        private readonly string _configFilePath;

        public ConfigManager(string configFilePath)
        {
            _configFilePath = configFilePath;
            _config = XDocument.Load(configFilePath);
        }

        public void UpdateConnectionString(string name, string server, string initialCatalog, string userId, string password)
        {
            var connectionStrings = _config.Descendants("connectionStrings").FirstOrDefault();
            if (connectionStrings != null)
            {
                var connectionStringElement = connectionStrings.Elements("add")
                                                               .FirstOrDefault(e => e.Attribute("name")?.Value == name);
                if (connectionStringElement != null)
                {
                    var connectionString = connectionStringElement.Attribute("connectionString")?.Value;
                    if (connectionString != null)
                    {
                        var builder = new System.Data.SqlClient.SqlConnectionStringBuilder(connectionString)
                        {
                            DataSource = server,
                            InitialCatalog = initialCatalog,
                            UserID = userId,
                            Password = password
                        };

                        connectionStringElement.SetAttributeValue("connectionString", builder.ConnectionString);
                        _config.Save(_configFilePath);
                        Console.WriteLine($"Updated connection string name '{name}' with new parameters.");
                    }
                    else
                    {
                        Console.WriteLine($"Connection string for name '{name}' is null.");
                    }
                }
                else
                {
                    Console.WriteLine($"Connection string name '{name}' not found.");
                }
            }
            else
            {
                Console.WriteLine("connectionStrings section not found.");
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            string configFilePath = @"WhosWhere.Website\Web.config";
            string connectionStringName = "WhosWhereConnectionString"; // Replace with the connection string name you want to find

            ConfigManager configManager = new ConfigManager(configFilePath);

            // Update connection string with specific parameters
            string server = "new-server";
            string initialCatalog = "new-catalog";
            string userId = "new-user";
            string password = "new-password";
            configManager.UpdateConnectionString(connectionStringName, server, initialCatalog, userId, password);
        }
    }
}