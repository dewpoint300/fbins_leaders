[CmdletBinding()]

 Param(
    
    [String]
    $User = $env:USERNAME,

    [String]
    $Source = "C:\Temp",

    [String]
    $Destination = "C:\Users\$User"
)

$ErrorActionPreference = 'SilentlyContinue'

# Create compressed archives of user data to be migrated

Expand-Archive -Path "$Source\$env:USERNAME-UserData.zip" -DestinationPath $Destination
Expand-Archive -Path "$Source\$env:USERNAME-ChromeData.zip" -DestinationPath "$Destination\AppData\Local\Google\Chrome\User Data"
Expand-Archive -Path "$Source\$env:USERNAME-EdgeData.zip" -DestinationPath "$Destination\AppData\Local\Microsoft\Edge\User Data"
