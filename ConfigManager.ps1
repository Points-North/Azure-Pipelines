# Create a powershell script, given a file such as web.config or app.config, will replace the associated value for a given key in the <appSettings> section.

param (
    [string]$filePath,
    [string]$key,
    [string]$newValue
)

# Load the XML file
[xml]$xml = Get-Content $filePath

# Find the appSettings node
$appSettings = $xml.configuration.appSettings

if ($appSettings) {
    # Find the key to update
    $setting = $appSettings.add | Where-Object { $_.key -eq $key }

    if ($setting) {
        # Update the value
        $setting.value = $newValue
        # Save the updated XML back to the file
        $xml.Save($filePath)
        Write-Output "Updated key '$key' with new value '$newValue'."
    } else {
        Write-Output "Key '$key' not found in the appSettings section."
    }
} else {
    Write-Output "appSettings section not found in the configuration file."
}


# Provide another Powershell script that allows specifically changing only the Server, Initial Catalog, User ID, and Password (keeping all of the existing settings) for a given name within <connectionStrings>, exemplified by #file:'WhosWhere.Aca.Printing.StandardShell\App.config' .

param (
    [string]$filePath,
    [string]$connectionName,
    [string]$newServer,
    [string]$newInitialCatalog,
    [string]$newUserID,
    [string]$newPassword
)

# Load the XML file
[xml]$xml = Get-Content $filePath

# Find the connectionStrings node
$connectionStrings = $xml.configuration.connectionStrings

if ($connectionStrings) {
    # Find the connection string to update
    $connection = $connectionStrings.add | Where-Object { $_.name -eq $connectionName }

    if ($connection) {
        # Parse the existing connection string
        $connectionString = $connection.connectionString
        $connectionStringParts = $connectionString -split ";"

        # Update the relevant parts
        foreach ($part in $connectionStringParts) {
            if ($part -ilike "Server=*") {
                $part = "Server=$newServer"
            } elseif ($part -ilike "Initial Catalog=*") {
                $part = "Initial Catalog=$newInitialCatalog"
            } elseif ($part -ilike "User ID=*") {
                $part = "User ID=$newUserID"
            } elseif ($part -ilike "Password=*") {
                $part = "Password=$newPassword"
            }
        }

        # Reconstruct the connection string
        $newConnectionString = [string]::Join(";", $connectionStringParts)
        $connection.connectionString = $newConnectionString

        # Save the updated XML back to the file
        $xml.Save($filePath)
        Write-Output "Updated connection string for '$connectionName'."
    } else {
        Write-Output "Connection string with name '$connectionName' not found."
    }
} else {
    Write-Output "connectionStrings section not found in the configuration file."
}