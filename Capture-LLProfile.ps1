[CmdletBinding()]

 Param(
    
    [Parameter]
    [String]
    $User = $env:USERNAME,

    [Parameter]
    [System.IO.Directory]
    $Source = "C:\Users\$User",

    [Parameter]
    [System.IO.Directory]
    $Destination = "C:\Temp"
)

$ErrorActionPreference = 'SilentlyContinue'

# Dump browser cache for efficiency
# Edge
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Default\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Microsoft\Edge\User Data\Profile*\Code Cache" -Recurse | Remove-Item -Recurse -Force
# Chrome
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Default\Code Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Service Worker\CacheStorage" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Cache" -Recurse | Remove-Item -Recurse -Force
Get-ChildItem "$Source\AppData\Local\Google\Chrome\User Data\Profile*\Code Cache" -Recurse | Remove-Item -Recurse -Force


# Create compressed archives of user data to be migrated
Compress-Archive -Path "$Source\Documents" -Update -DestinationPath $Destination\$User-UserData.zip
Compress-Archive -Path "$Source\Desktop" -Update -DestinationPath $Destination\$User-UserData.zip
Compress-Archive -Path "$Source\Pictures" -Update -DestinationPath $Destination\$User-UserData.zip
Compress-Archive -Path "$Source\AppData\Local\Google\Chrome\User Data" -Update -DestinationPath $Destination\$User-ChromeData.zip
Compress-Archive -Path "$Source\AppData\Local\Microsoft\Edge\User Data" -Update -DestinationPath $Destination\$User-EdgeData.zip

# Open explorer to show the files created
Write-Host "Open explorer to show the files created - please copy these files to the VDI"
Start-Process explorer.exe -ArgumentList $Destination