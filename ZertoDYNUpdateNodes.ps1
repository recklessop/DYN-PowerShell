#####################################################################################
# Created by Justin Paul, Zerto Tech Alliances Architect, 2017                      #
#                                                                                   #
#                                                                                   #
# Original script forked from:                                                      #
# http://www.jjclements.co.uk/2015/12/04/powershell-script-for-dyn-dynect-rest-api/ #
#                                                                                   #
#This script/function lists a node's DNS A record from Dynect                       #
#for the predefined zone using the Dynect REST API                                  #
#####################################################################################

####################################
#Start of user changeable variables#
####################################
#
#DYN Account Login Information
#
$customername = "zerto"
$username = "jpaul"
$password = "password"
$zone = "labrack.xyz"

###########################################################
# Start of Server ARecord List for changes                #
# Note You only need to fill in the FQDN and NewIP fields #
# The record_id field will be aquired via REST call       #
###########################################################
$DynNodes = 
@(
[pscustomobject]@{fqdn="server1.labrack.xyz";NewIp="206.55.216.26";record_id=""},
[pscustomobject]@{fqdn="server2.labrack.xyz";NewIp="2.2.2.2";record_id=""},
[pscustomobject]@{fqdn="server3.labrack.xyz";NewIp="3.3.3.3";record_id=""}
)

##################################
#End of user changeable variables#
##################################
 
function dynListNodes
{
     param([string]$zone)
 
     try
     {
 
     
    #Format credentials accordingly for the body content of the initial request below
     $credentials = '{"customer_name":"' + $customername + '","user_name":"' + $username + '","password":"' + $password + '"}'
 
     
    #Use credentials to request and store a session token from Dynect for later use
     $result = Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Post -ContentType "application/json" -Body $credentials
     $token = $result.data.token
 
    #Create the header with the session token data for subsequent Dynect calls
     $headers = @{"Auth-Token" = "$token"}
     
    #Get Existing Node Records for the Zone
     $records = (Invoke-RestMethod -Uri "https://api.dynect.net/REST/AllRecord/$zone/" -Method GET -ContentType "application/json" -Headers $headers).data

    #Split Results and list just the ARecords then for each ARecord compare to list of fqdn's we want to update
     $records = $records.split(" ")
     $records | foreach {
        $items = $_.split("/")
        if ($items[2] -eq "ARecord")
        {
            Write-Host "Comparing to the list of Servers to change"
            foreach ($node in $DynNodes)
            {
                if ($node.fqdn -eq $items[4])
                {
                    write-host "Match! "  $node.fqdn
                    $node.record_id = $items[5]
                }
                
            }
        }

    # Print out the updated FQDN IP address mapping table
    Write-Host "`nFQDNs will be updated as follows:"
    $DynNodes | Format-Table -Auto

    # Update Records that Need updating (Based on Record_id Present)
        foreach ($node in $DynNodes)
        {
            if ($node.record_id -ne "")
            {
                Write-Host $node.fqdn - "Run Update REST API!!!!"
                $body = '{"rdata":{"address":"' + $node.NewIp + '"}}'
                $nodefqdn = $node.fqdn
                $nodeid = $node.record_id
                Invoke-RestMethod -Uri "https://api.dynect.net/REST/ARecord/$zone/$nodefqdn/$nodeid/" -Method PUT -ContentType "application/json" -Headers $headers -B $body | Output-Null
            }
                
        }
    }

    #Publish Updates
    Invoke-RestMethod -Uri "https://api.dynect.net/REST/Zone/$zone/" -Method PUT -ContentType "application/json" -Headers $headers -Body '{"publish":true}' | Output-Null

    #Remove the session token/logout and suppress any output    
    Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers  | Output-Null
 
     }
 
     catch
     {
     }
}

$Operation = $env:ZertoOperation
$Operation = "FailoverBeforeCommit"
$VPG = $env:ZertoVPGName
$time = Get-Date
 
if ($Operation -eq "Test") {
    "$time VPG: $VPG was tested." >> "C:\DR_IPChange_Log.txt"
    Exit
}
 
if ($Operation -eq "FailoverBeforeCommit") {
    "$time Failover before commit was performed. VPG: $VPG" >> "C:\DR_IPChange_Log.txt"
    #Run the function
    dynListNodes $zone
}
 
if ($Operation -eq "MoveBeforeCommit"){
    "$time Move before commit was performed. VPG: $VPG" >> "C:\DR_IPChange_Log.txt"
    #Run the function
    dynListNodes $zone
}

