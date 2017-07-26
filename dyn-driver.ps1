
Import-Module -Name .\dyn-functions.psm1

function dynLogIn
{

    param([string]$file)

    Get-Content $file | Foreach-Object{
        $var = $_.Split('=')
        New-Variable -Name $var[0] -Value $var[1]
    }

    #Format credentials accordingly for the body content of the initial request below
    $credentials = '{"customer_name":"' + $customername + '","user_name":"' + $username + '","password":"' + $password + '"}'
 
     
    #Use credentials to request and store a session token from Dynect for later use
    $result = Invoke-RestMethod -Uri https://api.dynect.net/REST/Session -Method Post -ContentType "application/json" -Body $credentials
    $token = $result.data.token

    return $token
}

[string]$token = dynLogIn ".\config.txt"

$zone = "labrack.xyz"
$type = "ARecord"

#$mynodes = dynGetNodes $type $zone $token


#foreach ($node in $mynodes) 
#{
#    Write-Host $node "`n"
#}

dynLogOut $token