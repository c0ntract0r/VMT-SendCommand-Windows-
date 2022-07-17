# VMT-SendCommand-Windows
Automated Creation of Windows virtual machines from a template with the given settings(if provided value),updating or installing VM tools, setting DNS servers,
changing IP address, joining to a domain and restarting on VMware Vcenter servers.

## How does it work
When running the script, user is prompted to enter a vcenter server name in FQDN, after which is prompted to enter username and password with the necessary priveleges.
The script itself is self-explanatory, as it is prompting users to enter necessary information, such as the datastore to create on, the template, and the cluster. VMhost
is selected randomly. After creating the virtual machine, it is necessary to connect to a network and power the new server on. A sleep timer is set to 30 seconds to make sure
that the vm will be up and running.
After installing/updating vmtools and getting necessary information, another prompt comes to connect to new server with a local user. Because `Invoke-VMscipt` is sending the 
commands with non-administrative rights, it is important to create a powershell process with elevated rights, and set the given IP and DNS information that way. After sending
the script, session is closed.

## Prerequisites
* [VMware PowerCLI](https://developer.vmware.com/web/tool/vmware-powercli)
* Vsphere user with the necessary permissions
* [Trusted root certificates installation](https://vdc-download.vmware.com/vmwb-repository/dcr-public/bc4fa31a-40ac-4aa9-a6a1-7171d1fff7f4/740990ee-4d65-4627-a9d4-0f046cb78aec/doc/GUID-9AF8E0A7-1A64-4839-AB97-2F18D8ECB9FE.html)

## Features
* Logging
* Basic Error handling
