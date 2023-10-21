[CmdletBinding()]

 Param(
    
    [String]
    $User = $env:USERNAME,

    [String]
    $Source = "C:\Users\$User",

    [String]
    $Destination = "C:\Temp"
)

$ErrorActionPreference = 'SilentlyContinue'

# Get 7za.exe if it isn't in the destination
if (!(Test-Path $Destination\7za.exe)){
$7zURL = "https://github.com/develar/7zip-bin/raw/master/win/x64/7za.exe"
Invoke-WebRequest -Uri $7zURL -OutFile "$Destination\7za.exe"
}

# Stop browser processes
Get-Process msedge* | Stop-Process -Force
Get-Process chrome* | Stop-Process -Force

# Dump browser cache for efficiency
# Edge
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Crashpad\reports" -Recurse | Remove-Item -Recurse -Force
# Chrome
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Crashpad\reports" -Recurse | Remove-Item -Recurse -Force

# Create compressed archives of user data to be migrated
& $Destination\7za.exe a $Destination\$User-UserData.zip "$Source\Desktop"
& $Destination\7za.exe a $Destination\$User-UserData.zip "$Source\Documents"
& $Destination\7za.exe a $Destination\$User-UserData.zip "$Source\Pictures"
& $Destination\7za.exe a $Destination\$User-ChromeData.zip "$Source\AppData\Local\Google\Chrome\User Data"
& $Destination\7za.exe a $Destination\$User-EdgeData.zip "$Source\AppData\Local\Microsoft\Edge\User Data"

# Open explorer to show the files created
Write-Host "Open explorer to show the files created - please copy these files to the VDI"
Start-Process explorer.exe -ArgumentList $Destination