$hostname = hostname
$output_file = ".\" + $hostname + "_info.txt"

Write-Output @"
[*] ======================= [*]
Gathering system information...
[*] ======================= [*]
"@
# cmdlet to retrieve system information
Get-ComputerInfo | Tee-Object -FilePath $output_file

Write-Output @"

[*] ======================= [*]
  Rerieving running processes
[*] ======================= [*]
"@
# cmdlet to retrieve running processes
Get-Process | Tee-Object -FilePath $output_file -Append

Write-Output @"
[*] ======================= [*]
        End of Program
[*] ======================= [*]
"@