# Description
Get logon logs from your DCs, identify the workstations where accounts logs on  
Extract a .csv with account / workstation / date in the working directory.

# Preview
Running

![preview](https://github.com/arnaudluti/PS-LogonAudit/blob/master/preview.png?raw=true)

CSV extracted

![preview](https://raw.githubusercontent.com/arnaudluti/PS-LogonAudit/master/preview_result.png)

# Prerequisites
Active directory powershell module (installed with AD RSAT)  
Success logon audit activated on your DCs, see :  
https://support.microsoft.com/en-us/help/556015, Option 1, part 1.  
You can increase the 'security' eventlog size on your DCs, to get more events

# How-to
1. Fill-up the $accounts list with the domain accounts you want to search for  
2. Run the script
