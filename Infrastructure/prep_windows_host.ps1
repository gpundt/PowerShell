# Installs Git application
function Install-Git {
    Write-Output "[*] Installing Git..."
    # get latest download url for git-for-windows 64-bit exe
    $git_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"
    
    $asset = Invoke-RestMethod -Method Get -Uri $git_url | % assets | where name -like "*64-bit.exe"
    # download installer
    $installer = "$env:temp\$($asset.name)"
    
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer
    # run installer
    $git_install_inf = ".\vars\git_inf.txt"
    $install_args = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$git_install_inf"""
    Start-Process -FilePath $installer -ArgumentList $install_args -Wait

    # verify installation
    git --version
    Write-Output "[*] Git Installed!"
}

# Installs VSCode
function Install-VSCode {
    param (
        [Parameter()]
        [ValidateSet('local','global')]
        [string[]]$Scope = 'global',

        [parameter()]
        [ValidateSet($true,$false)]
        [string]$CreateShortCut = $true
    )
    Write-Output "[*] Installing VS Code..."

    # Windows Version x64
    # Define the download URL and the destination
    $Destination = "$env:TEMP\vscode_installer.exe"
    $VSCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"

    # User Installation
    if ($Scope  -eq 'local') {
        $VSCodeUrl = $VSCodeUrl + '-user'
    }

    $UnattendedArgs = '/verysilent /mergetasks=!runcode'

    # Download VSCode installer
    #Write-Host Downloading VSCode
    Invoke-WebRequest -Uri $VSCodeUrl -OutFile $Destination # Install VS Code silently
    #Write-Host Download finished

    # Install VSCode
    #Write-Host Installing VSCode
    Start-Process -FilePath $Destination -ArgumentList $UnattendedArgs -Wait -Passthru
    #Write-Host Installation finished

    # Remove installer
    #Write-Host Removing installation file
    Remove-Item $Destination
    #Write-Host Installation file removed
    Write-Output "[*] VS Code Installed!"
}

# Installs Python
function Install-Python3-12 {
    Write-Output "[*] Installing Python 3.12..."
    # Get latest version of python from official site
    $pythonUrl = "https://www.python.org/ftp/python/3.12.5/python-3.12.5-amd64.exe"
    $pythonInstaller = "$($env:TEMP)\python.exe"
    Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller

    # Install python with default settings
    Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet" -Wait

    # Add python to the PATH environment variable
    $pythonPath = Join-Path $env:ProgramFiles "Python312"
    [System.Environment]::SetEnvironmentVariable("Path", "$($env:Path);$pythonPath", "User")

    #verify installation
    python --version 
    Write-Output "[*] Python Installed!"
}

# Function calls
Install-Git
Install-VSCode
Install-Python3-12
