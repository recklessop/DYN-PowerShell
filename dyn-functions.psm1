#####################################################################################
# DYN Powershell wrapper functions                                                  #
#                                                                                   #
# Used along with a driver script to login and execute REST calls via Powershell    #
#                                                                                   #
#                                                                                   #
#                                                                                   #
# Created by Justin Paul, Zerto Tech Alliances Architect, 2017                      #
# for use with Zerto Post-Failover scripting to change DNS after failover to DR     #
#                                                                                   #
#                                                                                   #
#####################################################################################

function dynLogOut
{
    
    param([string]$token)
    
 
    #Create the header with the session token data for subsequent Dynect calls
    $headers = @{"Auth-Token" = "$token"}


    #Remove the session token/logout and suppress any output
    Invoke-RestMethod -Uri "https://api.dynect.net/REST/Session" -Method Delete -ContentType "application/json" -Headers $headers | out-null
}

#function dynLogIn
#{

#    param([string]$file)

#    Get-Content $file | Foreach-Object{
#        $var = $_.Split('=')
#        New-Variable -Name $var[0] -Value $var[1]
#    }

    #Format credentials accordingly for the body content of the initial request below
#    $credentials = '{"customer_name":"' + $customername + '","user_name":"' + $username + '","password":"' + $password + '"}'
 
     
    #Use credentials to request and store a session token from Dynect for later use
#    $result = Invoke-RestMethod -Uri https://api.dynect.net/REST/Session -Method Post -ContentType "application/json" -Body $credentials
#    $token = $result.data.token

#    return $token
#}

function dynGetNodes
{
    param([string]$type, [string]$zone, $token)
    
 
    #Create the header with the session token data for subsequent Dynect calls
    $headers = @{"Auth-Token" = "$token"}

    $result = @()
       
    #Get Existing Node Records for the Zone
    $records = (Invoke-RestMethod -Uri "https://api.dynect.net/REST/AllRecord/$zone/" -Method GET -ContentType "application/json" -Headers $headers).data


    #Split Results and list just the ARecords
    $records = $records.split(" ")
    $records | foreach {
        $items = $_.split("/")
        if ($items[2] -eq $type)
        {
            Echo $items[4]
            $result += $result
        }
    }
    return $result
}