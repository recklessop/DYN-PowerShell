


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

# Login to DYN API and get Auth Token
#Format credentials accordingly for the body content of the initial request below
$credentials = '{"customer_name":"' + $customername + '","user_name":"' + $username + '","password":"' + $password + '"}'
 
#Use credentials to request and store a session token from Dynect for later use
$result = Invoke-RestMethod -Uri https://api.dynect.net/REST/Session -Method Post -ContentType "application/json" -Body $credentials
$token = $result.data.token

#Create the header with the session token data for subsequent Dynect calls
$headers = @{"Auth-Token" = "$token"}




Write-Host "FQDNs will be updated as follows:"
foreach ($node in $DynNodes)
{
    $node | Format-Table -Auto
}




write-host "Logout"
#Remove the session token/logout and suppress any output
Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers