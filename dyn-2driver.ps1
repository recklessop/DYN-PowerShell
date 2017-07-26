
Import-Module -Name .\dyn-functions.psm1


$token = dynLogIn ".\config.txt"

$zone = "labrack.xyz123"
$type = "ARecord"

$mynodes = dynGetNodes $type $zone $token


foreach ($node in $mynodes) 
{
    Write-Host $node "`n"
}

dynLogOut $token
