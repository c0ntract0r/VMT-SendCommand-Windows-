<#
Created by c0ntract0r. The following version is 2.0.0, added on the first version getting settings of template, logging, somewhat error handling
GNU General Public Licence version 3.0
#>




# Main logging function to create for logging
Function Write-LogInfo {
  [CmdletBinding()]

  Param (
    [Parameter(Mandatory=$true,Position=0)][string]$LogPath,
    [Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)][string]$Message,
    [Parameter(Mandatory=$false,Position=2)][switch]$TimeStamp,
    [Parameter(Mandatory=$false,Position=3)][switch]$ToScreen
  )

  Process {
    #Add TimeStamp to message if specified
    If ( $TimeStamp -eq $True ) {
      $Message = "$Message [$([DateTime]::Now)]"
    }

    #Write Content to Log
    Add-Content -Path $LogPath -Value $Message

    #Write to screen for debug mode
    Write-Debug $Message

    #Write to scren for ToScreen mode
    If ( $ToScreen -eq $True ) {
      Write-Output $Message
    }
  }
}

#initial variables, the $count variable is to be reset on instances of Get
$count = 0
$ClusterName = ''
$TemplateName = ''
$logPath = "$env:USERPROFILE\Desktop\vcenter.log"
$DatastoreName = ''

Clear-Host

# Enter the server name
$ServerName = Read-Host -Prompt "Enter the server name in FQDN"

# Connecting to the selected server with user credentials
$ConnectMessage = "Enter username and password to connect to server '{0}'" -f $ServerName
$G_Cred = Get-Credential -Message $ConnectMessage
Try {
    Connect-VIServer -Server $ServerName -Credential $G_Cred -ErrorAction Stop
    Write-LogInfo -LogPath $logPath -Message "[INFO]Connected to server $Servername through port 443" -TimeStamp
}
Catch {
    Write-LogInfo -LogPath $logPath -Message "[ERROR]Could not connect to $Servername. Incorrect user/password or server name" -TimeStamp
    Exit

}

# Clear the screen
Clear-Host

# Getting the cluster names and prompting for input
while ($true) {
    Write-Host "Getting the Clusters:`n"
    $tempVar = Get-Cluster | Select-Object Name | ForEach-Object { $_.Name }; $tempVar

    if ($tempVar.Count -eq 1 -and $count -ne 3) {
        $ClusterName = Read-Host "`nOnly one cluster found with name $tempVar.Press 'enter' to select the cluster"
        
        if ($ClusterName -eq '' -or $ClusterName -eq $tempVar) { 
            $ClusterName = $tempVar
            Write-LogInfo -LogPath $logPath -Message "[INFO]$ClusterName Cluster Selected." -TimeStamp
            break
        }
        else { 
        Write-Host "Wrong cluster selected with name $ClusterName.Try again."
        Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong cluster selected with name $ClusterName.Try again." -TimeStamp; 
        $count = $count + 1; Start-Sleep -Seconds 1;
        continue 
        }
    }
    elseif($tempVar -gt 1 -and $count -ne 3)
    {

        $ClusterName = Read-Host "More than 1 cluster found. Enter a valid cluster name"
        if ($tempVar -Contains $ClusterName) {
            Write-Host "Cluster with name $ClusterName has been selected."
            Write-LogInfo -LogPath $logPath -Message "[INFO]Cluster $ClusterName has been set for later usage." -TimeStamp;
            Start-Sleep -Seconds 1;
            break
        }
        else { 
            $count = $count + 1;  
            Write-Host "Wrong Cluster with name $ClusterName. Try again";
            Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong cluster selected with name $ClusterName.Try again." -TimeStamp;
            Start-Sleep -Seconds 1;
            continue;
        }
    }
    else {
        Write-Host "Too many atttempts or no cluster found.Terminating the program."
        Start-Sleep -Seconds 1;
        Write-LogInfo -LogPath $logPath -Message "[ERROR]Too many attempts when setting cluster. Run the program again" -TimeStamp;
        Disconnect-VIServer -Server $ServerName -Confirm:$false;
        Exit
    }
}

# Clear the screen
Clear-Host



# Getting the datastore names and prompting for input
$count = 0

while ($true) {
    Write-Host "Getting the Datastores:`n"
    $tempVar = Get-Datastore | Select-Object Name | ForEach-Object { $_.Name }; $tempVar

    if ($tempVar.Count -eq 1 -and $count -ne 3) {
        $DatastoreName = Read-Host "`nOnly one datastore found with name $tempVar.Press 'enter' to select the datastore"
        
        if ($DatastoreName -eq '' -or $DatastoreName -eq $tempVar) { 
            $DatastoreName = $tempVar
            Write-LogInfo -LogPath $logPath -Message "[INFO]$DatastoreName Datastore Selected." -TimeStamp
            break
        }
        else { 
        Write-Host "Wrong datastore selected with name $DatastoreName.Try again."
        Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong datasote selected with name $DatastoreName.Try again." -TimeStamp; 
        $count = $count + 1; Start-Sleep -Seconds 1;
        continue 
        }
    }
    elseif($tempVar -gt 1 -and $count -ne 3)
    {

        $DatastoreName = Read-Host "More than 1 datastore found. Enter a valid datastore name"
        if ($tempVar -Contains $DatastoreName) {
            Write-Host "Datastore with name $DatastoreName has been selected."
            Write-LogInfo -LogPath $logPath -Message "[INFO]Datastore $DatastoreName has been set for later usage." -TimeStamp;
            Start-Sleep -Seconds 1;
            break
        }
        else { 
            $count = $count + 1;  
            Write-Host "Wrong datastore with name $DatastoreName. Try again";
            Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong datastore selected with name $DatastoreName.Try again." -TimeStamp;
            Start-Sleep -Seconds 1;
            continue;
        }
    }
    else {
        Write-Host "Too many atttempts or no datastore found.Terminating the program."
        Start-Sleep -Seconds 1;
        Write-LogInfo -LogPath $logPath -Message "[ERROR]Too many attempts when setting datastore. Run the program again" -TimeStamp;
        Disconnect-VIServer -Server $ServerName -Confirm:$false;
        Exit
    }
}

# Clear the screen
Clear-Host

# Getting the template names and prompting for input
$count = 0

while ($true) {
    Write-Host "Getting the Templates:`n"
    $tempVar = Get-Template | Select-Object Name | ForEach-Object { $_.Name }; $tempVar

    if ($tempVar.Count -eq 1 -and $count -ne 3) {
        $TemplateName = Read-Host "`nOnly one template found with name $tempVar.Press 'enter' to select the template"
        
        if ($TemplateName -eq '' -or $TemplateName -eq $tempVar) { 
            $TemplateName = $tempVar
            Write-LogInfo -LogPath $logPath -Message "[INFO]$TemplateName Template Selected." -TimeStamp
            break
        }
        else { 
        Write-Host "Wrong template selected with name $TemplateName.Try again."
        Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong datasote selected with name $TemplateName.Try again." -TimeStamp; 
        $count = $count + 1; Start-Sleep -Seconds 1;
        continue 
        }
    }
    elseif($tempVar -gt 1 -and $count -ne 3)
    {

        $TemplateName = Read-Host "More than 1 template found. Enter a valid template name"
        if ($tempVar -Contains $TemplateName) {
            Write-Host "Template with name $TemplateName has been selected."
            Write-LogInfo -LogPath $logPath -Message "[INFO]Template $TemplateName has been set for later usage." -TimeStamp;
            Start-Sleep -Seconds 1;
            break
        }
        else { 
            $count = $count + 1;  
            Write-Host "Wrong template with name $TemplateName. Try again";
            Write-LogInfo -LogPath $logPath -Message "[WARNING]Wrong template selected with name $TemplateName.Try again." -TimeStamp;
            Start-Sleep -Seconds 1;
            continue;
        }
    }
    else {
        Write-Host "Too many atttempts or no template found.Terminating the program."
        Start-Sleep -Seconds 2;
        Write-LogInfo -LogPath $logPath -Message "[ERROR]Too many attempts when setting template. Run the program again" -TimeStamp;
        Disconnect-VIServer -Server $ServerName -Confirm:$false;
        Exit
    }
}

Clear-Host

# Configuration parameters for newly created VM
$VMname = Read-Host "Enter new VM name"
$originalVDisk = Get-Template $TemplateName | Select-Object @{N="GB";E={[string]::Join(',',( $_.ExtensionData.Config.Hardware.Device | where{$_.GetType().Name -eq "VirtualDisk"} | %{$_.CapacityInKB / 1024 / 1024}))}} | ForEach-Object {$_."GB"}
$count = 0

while ($true) 
{ 
    $DiskSpace = Read-Host "Enter disk size(no less then $originalVDisk GB, press enter to set as default)"
    if ($Diskspace -gt $originalVDisk)
        {
            Write-LogInfo -LogPath $logPath -Message "[INFO]Disk space set to $Diskspace.Continuing..."
            Start-Sleep -Seconds 1
            break
        }
    elseif ($DiskSpace -eq '' -or $DiskSpace -eq $originalVDisk)
        {
            $DiskSpace = $originalVDisk
            Write-LogInfo -LogPath $logPath -Message "[INFO]Disk space set to $Diskspace.Continuing..."
            Start-Sleep -Seconds 1
            break
        }
    elseif ($DiskSpace -lt $originalVDisk -and $count -ne 2) {
        $count = $count + 1
        Write-Host "Can't set to $Diskspace.Try again"
        continue
    }
    else {
        Write-Host "Too many failed attempts. Terminating the program."
        Write-LogInfo -LogPath $logPath -Message "[ERROR]Too many failed attempts when setting disk space."
        Exit
    }
}

# Get a random host within the cluster, get the datastore type and template
$VMHost = Get-Cluster $ClusterName | Get-VMHost -State Connected | Get-Random

$originalVRAM = Get-Template -Name $TemplateName | Select-Object @{N="RAM (GB)";E={$_.ExtensionData.Config.Hardware.MemoryMB / 1024}} | ForEach-Object {$_."RAM (GB)"}
$MemoryinGB = Read-Host -Prompt "Enter Memory size(To set Default:$originalVRAM, press enter)"
if ($MemoryinGB -eq '') { $MemoryinGB = $originalVRAM }

$originalCPUCount = Get-Template -Name $TemplateName | Select-Object @{N="vCPU";E={$_.ExtensionData.Config.Hardware.NumCPU}} |ForEach-Object { $_."vCPU" }
$CpuNumberCount = Read-Host -Prompt "Enter CPU count(To set Default:$originalCPUCount, press enter)"
if ($CpuNumberCount -eq '') { $CpuNumberCount = $originalCPUCount }

$originalCoresPerCPU = Get-Template -Name $TemplateName | Select-Object @{N="Core";E={$_.ExtensionData.Config.Hardware.NumCoresPerSocket}} | ForEach-Object {$_."Core"}
$CorePerCPU = Read-Host -Prompt "Enter cores per CPU count(To set Default:$originalCoresPerCPU, press enter)"
if ($CorePerCPU -eq '') { $CorePerCPU = $originalCoresPerCPU }

# Ask user for a location(either root or in folder/pool)
$ForSelection = Read-Host -Prompt "Do you want your VM to be in root folder or datacenter(Y/N)"

if( ($ForSelection -like 'y') -or ($ForSelection -like 'ye') -or ($ForSelection -like 'yes') ) {
    Write-LogInfo -LogPath $logPath -Message "[INFO]Creating VM with name $VMname in root...."
    try {
        New-VM -Template $TemplateName -Name $VMname -VMHost $VMHost -Datastore $DatastoreName | Set-VM -NumCpu $CpuNumberCount -MemoryGB $MemoryinGB -Confirm:$false -CpuHotAddEnabled $true -CoresPerSocket $CorePerCPU -ErrorAction Stop
    }
    catch {
        Write-LogInfo -LogPath $logPath -Message "[ERROR]Could not create VM $VMname. Error encountered(Most likely, permission denied)" -TimeStamp
        Write-Host "Error encountered(Most likely, permission denied)"
        Start-Sleep -Seconds 2
        Disconnect-VIServer -Server $ServerName -Confirm:$false;
        Exit
    }
    Get-HardDisk -VM $VMname | Set-HardDisk -CapacityGB $DiskSpace
}

elseif( ($ForSelection -like 'n') -or ($ForSelection -like 'no') ) {
    [int]$FolderOrResPool = Read-Host "Enter either (1) for creating in folder or (2) to create in resource pool(VIContainer).Anything else means exit"
    
    # If user chose to create in a folder
    if ($FolderOrResPool -eq 1) {
        Get-Folder | Select-Object Name | ForEach-Object { $_.Name }
        $SetFolName = Read-Host 'Enter a folder name to create in'
        Write-LogInfo -LogPath $logPath -Message "[INFO]Creating VM with name $VMname in folder $SetFolName..."
        try {
            New-VM -Template $TemplateName -Name $VMname -VMHost $VMHost -Location $SetFolName -Datastore $DatastoreName | Set-VM -NumCpu $CpuNumberCount -MemoryGB $MemoryinGB -Confirm:$false -CpuHotAddEnabled $true -CoresPerSocket $CorePerCPU -ErrorAction Stop
        }
        catch
        {
            Write-LogInfo -LogPath $logPath -Message "[ERROR]Could not create VM $VMname. Error encountered(Most likely, permission denied)" -TimeStamp
            Write-Host "Error encountered(Most likely, permission denied)"
            Start-Sleep -Seconds 2
            Disconnect-VIServer -Server $ServerName -Confirm:$false;
            Exit
        }
        Start-Sleep -Seconds 3
        Get-HardDisk -VM $VMname | Set-HardDisk -CapacityGB $DiskSpace
    }

    # If user chose to create in a resource pool
    elseif ($FolderOrResPool -eq 2) {
        Get-ResourcePool | Select-Object Name | ForEach-Object { $_.Name }
        $SetResPoolName = Read-Host 'Enter a valid resource pool name'; $GetResPoolName = Get-ResourcePool -Name $SetResPoolName
        Write-LogInfo -LogPath $logPath -Message "[INFO]Creating VM with name $VMname in folder $SetResPoolName..."
        try{
            New-VM -Template $TemplateName -Name $VMname -VMHost $VMHost -ResourcePool $GetResPoolName -Datastore $DatastoreName | Set-VM -NumCpu $CpuNumberCount -MemoryGB $MemoryinGB -Confirm:$false -CpuHotAddEnabled $true -CoresPerSocket $CorePerCPU -ErrorAction Stop
        }
        catch {
            Write-LogInfo -LogPath $logPath -Message "[ERROR]Could not create VM $VMname. Error encountered(Most likely, permission denied)" -TimeStamp
            Write-Host "Error encountered(Most likely, permission denied)"
            Start-Sleep 2
            Disconnect-VIServer -Server $ServerName -Confirm:$false;
            Exit 
        }
        Start-Sleep -Seconds 3
        Get-HardDisk -VM $VMname | Set-HardDisk -CapacityGB $DiskSpace
    }

    # If user entered something else
    else {
        Write-Host "Sorry, I did not get it. Run program again." -ForegroundColor DarkRed
        Disconnect-VIServer -Server $ServerName -Confirm:$false;
        exit
    }
}

Clear-Host

# Time to set the network, hehe
Get-VirtualNetwork | Select-Object Name | ForEach-Object { $_.Name }
$VirtualNetwork = Read-Host "Select network adapter"
Get-VM -Name $VMname | Get-networkAdapter | Set-NetworkAdapter -NetworkName $VirtualNetwork -Confirm:$false
Write-LogInfo -LogPath $logPath -Message "[INFO]Setting network adapter with name $VirutalNetwork" -TimeStamp

Start-VM -VM $VMname -Confirm:$false
Start-Sleep -Seconds 30;

# Script for elevating powershell rights for scripts running
$EnterIp = Read-Host "Enter IP address to set"
$EnterCIDR = Read-Host "Enter Subnet mask as CIDR notation"
$DefaultGate = Read-Host "Enter default gateway"
$DNS1 = Read-Host "Enter first DNS Server IP"
$DNS2 = Read-Host "Enter second DNS Server IP"
$ComputerName = Read-Host "Enter new computer name"
$Domain = Read-Host "Enter domain name"

#Changing the connect and auth direction
$ConnectMessage = "Enter the username and password to connect to {0}" -f $VMname
$G_Cred = Get-Credential -Message $ConnectMessage

# Getting all adapters
$SecondaryScript = 'NetAdapter | Select-Object Name, InterfaceDescription'
Invoke-VMScript -VM $VMname -ToolsWaitSecs 15 -GuestCredential $G_Cred -ScriptText $SecondaryScript

$AdapterName = Read-Host "Enter adapter name"

# Elevating powershell to administrator rights(starting process)
$MainScript = '$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole))
    {
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
    }
else
    {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
    };'`
    + "New-NetIPAddress -InterfaceAlias '$AdapterName' -IPAddress $EnterIp -PrefixLength $EnterCIDR -DefaultGateway $DefaultGate;" `
    + "Set-DnsClientServerAddress -InterfaceAlias '$AdapterName' -ServerAddresses ('$DNS1', '$DNS2');" `
    + "Start-Sleep -Seconds 15;" `
    + "Add-Computer -DomainName '$Domain' -newname $ComputerName -Credential $G_Cred -Restart"


# Installing VM tools on the newly created virtual machine
Get-VM -Name $VMname | Update-Tools -NoReboot
Write-LogInfo -LogPath $logPath -Message "[INFO]Updating VM tools for $VMname." -TimeStamp

# Running the script for changing IP address and setting DNS
Write-LogInfo -LogPath $logPath -Message "[INFO]Sending the main script to virtual machine."
Invoke-VMScript -VM $VMname -ToolsWaitSecs 15 -GuestCredential $G_Cred -ScriptText $MainScript

# Disconnecting from the server
Write-LogInfo -LogPath $logPath -Message "[INFO]Disconnected from server $ServerName." -TimeStamp;
Disconnect-VIServer -Server $ServerName -Confirm:$false;
