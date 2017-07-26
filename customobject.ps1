


####################################
#Start of user changeable variables#
####################################

###########################
# DYN API Credentials     #
###########################
$customername = "zerto"
$username = "jpaul"
$password = "z0@xzxCk58"

############################################
# Start of Server ARecord List for changes #
############################################
$DynNodes = 
@([pscustomobject]@{fqdn="server1.labrack.xyz";ip="1.1.1.1";record_id=""},
[pscustomobject]@{fqdn="server2.labrack.xyz";ip="2.2.2.2";record_id=""},
[pscustomobject]@{fqdn="server3.labrack.xyz";ip="3.3.3.3";record_id=""})


##################################
#End of user changeable variables#
##################################
Write-Host "FQDNs will be updated as follows:"
foreach ($node in $DynNodes)
{
    $node | Format-Table -Auto
}




write-host "Logout"
#Remove the session token/logout and suppress any output
Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers