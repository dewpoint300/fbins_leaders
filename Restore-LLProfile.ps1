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

& $Source\7za.exe x "$Source\$User-UserData.zip" -o"$Destination" -r
& $Source\7za.exe x "$Source\$User-ChromeData.zip" -o"$Destination\AppData\Local\Google\Chrome\User Data" -r
& $Source\7za.exe x "$Source\$User-EdgeData.zip" -o"$Destination\AppData\Local\Microsoft\Edge\User Data" -r
