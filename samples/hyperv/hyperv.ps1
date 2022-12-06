Get-WindowsOptionalFeature -Online | Where { $_.FeatureName -match "hyper-" } | Where { $_.State -ne "Enabled" } | ForEach { Enable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName -All -NoRestart }

New-VMSwitch -SwitchName "Internal" -SwitchType Internal
New-NetIPAddress -InterfaceAlias "vEthernet (Internal)" -IPAddress 192.168.238.1 -PrefixLength 24
New-NetNat -Name "vEthernet (Internal)" -InternalIPInterfaceAddressPrefix 192.168.238.0/24

# dedicated local user for shared folders
# home vagrantfile and vars
