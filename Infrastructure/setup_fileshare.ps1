## Vairables ##
$directory = "C:\Sammich Share"
$fileshare_name = "Sammich Fileshare"

## Function to Create directory if it doesnt exist ##
function CreateDirectory {
    Write-Output "Creating Directory $($directory)..."
    If(!(Test-Path -PathType container $directory)) {
        New-Item -ItemType Directory -Path $directory | Out-Null
        Write-Output "Directory Created!`n" 
    }
    else {
        Write-Output "Directory already Exists!`n"
    } 
}

## Function to enable Network Discovery ##
function Enable-NetDiscovery {
    Write-Output "Enabling Network Discovery..."
    netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
    Write-Output "Network Discovery Enabled!`n"
}

## Function to make new directory a fileshare avaiable to the network ##
function CreateFileshare {
    Write-Output "Creating $($fileshare_name)..."
    try {
        Remove-SmbShare -Name $fileshare_name -Force
    }
    catch {    }
    New-SmbShare -Name $fileshare_name -Path $directory
    Write-Output "$($fileshare_name) Created!"
}

## Calls all functions ##
function main {
    CreateDirectory
    Enable-NetDiscovery
    CreateFileshare
}

main