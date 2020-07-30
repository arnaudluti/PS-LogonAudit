<#
    .SYNOPSIS
        Script en construction...
        Search for logon eventlogs on DCs, for defined accounts
    .DESCRIPTION
        Used to clarify on which machine those generic "service accounts" are used, and what for.
    .NOTES
        Author: arnaudluti
        Version: 1.0
        Date: 07/2020
		Other: Event Usable 4770 (kerberos ticket renew),4769/4768 (kerberos ticket asked), 4624 (opening session) , 4776
#>
#Prerequisites
Import-Module ActiveDirectory

#Static
$u=1
$runningPath="."
$dcs=Get-ADDomainController -filter * | Select -ExpandProperty Name
$accounts='user1','user2'
$results=@()

Foreach ($account in $accounts) {
    $d=1
    Write-Progress -Id 1 -activity "Searching logon eventlogs for $account" -Status "$u/$(($accounts).count) accounts in the queue" -PercentComplete (($u/$accounts.count)*100)
    ForEach ($dc in $dcs) {
        Write-Progress -ParentId 1 -activity "Searching on $dc" -Status "$d/$(($dcs).count) DCs surveyed" -PercentComplete (($d/$dcs.count)*100)
        try {
            Get-WinEvent -ComputerName $dc -FilterHashTable @{logname='security';id=4776;data=$account} -ErrorAction Stop | ForEach-Object {
                $idx=$_.Message.IndexOf("Workstation")
                $sourceComputer=$_.Message.SubString($idx).Split('')[5]
                $event = @{  
                    ComputerName        = $sourceComputer      
                    Account             = $account
                    Id                  = $_.id
                    DateLogged          = $_.timeCreated
                    Comment             = ''
                }
                $results+=New-Object -TypeName PSOBject -Property $event
            }
        }
        catch {
            $event = @{  
                ComputerName        = '' 
                Account             = $account
                Id                  = '' 
                DateLogged          = ''
                Comment             = "No logons logged for $account"       
            }
            $results+=New-Object -TypeName PSOBject -Property $event
        } $d++     
    } $u++
} 
$results | Export-Csv -Path $runningPath\logonAudit.csv -NoTypeInformation -Encoding UTF8 -Append