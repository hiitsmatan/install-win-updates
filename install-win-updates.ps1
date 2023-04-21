# Check if PSWindowsUpdate module is installed, and install it if it's not present
if (-not (Get-InstalledModule -Name PSWindowsUpdate -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name PSWindowsUpdate -Force
}

# Import the module
Import-Module PSWindowsUpdate

# Set the execution policy to allow the script to run
Set-ExecutionPolicy Bypass -Scope Process -Force

# Search for and install updates
try {
    Write-Host "Searching for updates..."
    $updates = Get-WindowsUpdate -NotCategory "Drivers" -NotTitle "Preview"
    
    if ($updates.Count -gt 0) {
        Write-Host "Updates found: $($updates.Count)"
        Write-Host "Installing updates..."
        Install-WindowsUpdate -AcceptAll -IgnoreReboot
        Write-Host "Updates installed successfully"
    } else {
        Write-Host "No updates available to install"
    }
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
