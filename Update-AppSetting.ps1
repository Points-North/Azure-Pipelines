# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Update Config App Settings
# Developed by Hans Dickel
# Root Repo geekfog/Azure-Pipelines
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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