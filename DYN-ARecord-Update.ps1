#####################################################################################
#This script/function was written using the Curl examples found in the following URL#
#http://dyn.com/blog/dynect-api-example-curl-managed-dns-aws-heroku-devops          #
#                                                                                   #
#This script/function creates a new node in Dynect and sets a DNS A record for it   #
#for the predefined zone using the Dynect REST API                                  #
#usage: dynectcreate <newnodename> <123.123.123.123>                                #
#####################################################################################
 
####################################
#Start of user changeable variables#
####################################
$customername = "mycompanyname"
$username = "james"
$password = "guessme"
$zone = "foo.bar"
##################################
#End of user changeable variables#
##################################
 
function dynectcreate
{
     param([string]$node, [string]$ipaddress)
 
     try
     {
 
     
#Format credentials accordingly for the body content of the initial request below
     $credentials = '{"customer_name":"' + $customername + '","user_name":"' + $username + '","password":"' + $password + '"}'
 
     
#Use credentials to request and store a session token from Dynect for later use
     $result = Invoke-RestMethod -Uri https://api2.dynect.net/REST/Session -Method Post -ContentType "application/json" -Body $credentials
     $token = $result.data.token
 
 
 
     
#Create the header with the session token data for subsequent Dynect calls
     $headers = @{"Auth-Token" = "$token"}
 
     
#Format the DNS record data accordingly for the body content of the new record request
     $recorddata = '{"rdata":{"address":"' + $ipaddress + '"}}'
 
     
#Create new DNS A record for the node (note: node is automatically created if it doesn't already exist as per API documentation) and suppress any output
     Invoke-RestMethod -Uri "https://api2.dynect.net/REST/ARecord/$zone/$node.$zone." -Method Post -ContentType "application/json" -Headers $headers -Body $recorddata | out-null
 
     
#Publish the zone (commit the change) and suppress any output
     Invoke-RestMethod -Uri "https://api2.dynect.net/REST/Zone/$zone" -Method Put -ContentType "application/json" -Headers $headers -Body '{"publish":true}' | out-null
 
     
#Remove the session token/logout and suppress any output
     Invoke-RestMethod -Uri "https://api2.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers | out-null
 
     }
 
     catch
     {
     }
}
