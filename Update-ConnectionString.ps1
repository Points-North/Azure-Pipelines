# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Update Config File Connection string
# Developed by Hans Dickel
# Root Repo geekfog/Azure-Pipelines
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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