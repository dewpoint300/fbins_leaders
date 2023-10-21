# Set output options
$outpath = "./"
$outfile = $outpath + "Test-ADDS-" + (Get-Date -Format MM-dd-yyyy-HHmm)+ ".txt"

# AD Domain to work on
$ADDomain = Get-ADDomain

# Start transcription
Start-Transcript $outfile


#Test DNS
Write-Host -ForegroundColor Black -BackgroundColor Yellow "Get DNS Forwarders"

$ADDomain.ReplicaDirectoryServers | ForEach-Object {
    
    Write-Host -ForegroundColor Yellow "Getting forwarders for $_"
    $Forwarders = Get-DnsServerForwarder -ComputerName $_
    $Forwarders | Format-Table


}

Write-Host -ForegroundColor Black -BackgroundColor Yellow "Testing inter-forest domain lookups"

$ADDomain.ReplicaDirectoryServers | ForEach-Object {
    
    Write-Host -ForegroundColor Yellow "Testing forest lookups on $_"
    Write-Host - ''
    Write-Host -ForegroundColor Yellow "Testing to fbinsmi.com"
    Resolve-DnsName -Type NS fbinsmi.com -Server $_ 
    Write-Host -ForegroundColor Yellow "Testing to leaderslife.fbinsmi.com"
    Resolve-DnsName -Type NS leaderslife.fbinsmi.com -Server $_
    Write-Host -ForegroundColor Yellow "Testing to leaderslife.local"
    Resolve-DnsName -Type A leaderslife.local -Server $_
    Resolve-DnsName -Type A file01.leaderslife.local -Server $_
}


$ADDomain.ReplicaDirectoryServers | ForEach-Object {
    
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "Running DC Diagnostics except SystemLog against $_"
    Write-Host -ForegroundColor Yellow "Quite mode - printing errors only"
    Write-Host - ''
    Invoke-Command -ComputerName $_ { dcdiag /q /skip:SystemLog }

}

$ADDomain.ReplicaDirectoryServers | ForEach-Object {
    
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "Running DC Diagnostics SystemLog test against $_"
    Write-Host -ForegroundColor Yellow "Quite mode - printing errors only"
    Write-Host - ''
    #Invoke-Command -ComputerName $_ { dcdiag /test:SystemLog }

}

Write-Host -ForegroundColor Black -BackgroundColor Yellow "Testing user query to trusted domain"
Write-Host -ForegroundColor Yellow "Testing administrator@fbinsmi.com"
Get-ADUser -Identity Administrator -Server 'fbinsmi.com'

Write-Host -ForegroundColor Yellow "Testing administrator@leaderslife.local"
Get-ADUser -Identity Administrator -Server 'leaderslife.local'

Stop-Transcript