############################################
# Start of Server ARecord List for changes #
############################################
$DynNodes = 
@([pscustomobject]@{fqdn="server1.labrack.xyz";ip="1.1.1.1"},
[pscustomobject]@{fqdn="server2.labrack.xyz";ip="2.2.2.2"},
[pscustomobject]@{fqdn="server3.labrack.xyz";ip="3.3.3.3"})
############################################
# Start of Server ARecord List for changes #
############################################


foreach ($node in $DynNodes)
{
    $node | Format-Table -Auto
}

write-host "Finished"