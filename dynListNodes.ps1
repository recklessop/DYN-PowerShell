#####################################################################################
# Created by Justin Paul, Zerto Tech Alliances Architect, 2017                      #
#                                                                                   #
# Original script forked from:                                                      #
# http://www.jjclements.co.uk/2015/12/04/powershell-script-for-dyn-dynect-rest-api/ #
#                                                                                   #
#This script/function lists a node's DNS A record from Dynect                       #
#for the predefined zone using the Dynect REST API                                  #
#usage: dynListNodes.ps1 <zonename>                                                 #
#####################################################################################
 
####################################
#Start of user changeable variables#
####################################
$customername = "zerto"
$username = "jpaul"
$password = "z0@xzxCk58"
#$zone = "foo.bar"
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
     $result = Invoke-RestMethod -Uri https://api.dynect.net/REST/Session -Method Post -ContentType "application/json" -Body $credentials
     $token = $result.data.token

 
#Create the header with the session token data for subsequent Dynect calls
     $headers = @{"Auth-Token" = "$token"}
     
#Get Existing Node Records for the Zone
     $records = (Invoke-RestMethod -Uri "https://api.dynect.net/REST/AllRecord/$zone/" -Method GET -ContentType "application/json" -Headers $headers).data




#Split Results and list just the ARecords
     $records = $records.split(" ")
     $records | foreach {
        $items = $_.split("/")
        if ($items[2] -eq "ARecord"){Echo $items[4]}
     }
     
#Remove the session token/logout and suppress any output
     Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers | out-null
 
     }
 
     catch
     {
     }
}