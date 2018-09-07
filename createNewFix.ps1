# Caution this script doesn't have proper error handling implemented currently. 
# It is possible for success messages to display when tasks did not succeed.
# If exceptions are displayed in the terminal during execution, success messages following them may not be valid.

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)] [String]$Name,
  [Parameter(Mandatory=$false)] [String]$User = "Default"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$fixBaseConfigRoot = $scriptDir + "\.FixBaseConfig"
$baseFixAppRoot = $fixBaseConfigRoot + "\SolutionTemplate"

function createRootDirectory {
    # Create root directory for new fix app. Calling 
    Param(
        [Parameter(Mandatory=$true)] [String]$newFixAppRoot
    )
    New-Item -ItemType directory -Path $newFixAppRoot
    Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n-- INFO --`t" 
    Write-Host -ForegroundColor Green -BackgroundColor Black ("Created Fix Application Root Directory: " + $newFixAppRoot + "`n")
}

function copyFixBase {
    # Copy contents from Fix.BaseApp to root directory of new fix app.
    Param(
        [Parameter(Mandatory=$true)] [String]$newFixAppRoot
    )
    Copy-Item -Force -Recurse -Verbose ($baseFixAppRoot + "\*") -Destination $newFixAppRoot
    if((Test-Path -Path ($newFixAppRoot + "\packages"))){
        Remove-Item -Recurse -Force ($newFixAppRoot + "\packages")
    }
    Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n-- INFO --`t" 
    Write-Host -ForegroundColor Green -BackgroundColor Black ("Base Files Have Been Copied To: " + $newFixAppRoot)    
}

function promptUserForNewName{
    # Prompt user to provide a new fix name for when a fix already exists with that name.
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "`nWould you like to try another name? `n`nEnter [Y] to try another fix application name, any other entry will end script execution."
    $userResponse = Read-Host
    if($userResponse.ToUpper().Trim() -eq "Y"){
        Write-Host -ForegroundColor Green -BackgroundColor Black "Enter new fix name: "
        $userResponse = Read-Host
        createNewFixProcess $userResponse
    }
    else{
        Write-Host -ForegroundColor Black -BackgroundColor Red "`n-- EXITING --" 
    }
}

function renameFix{
    # Replace occurences of FixBase with new fix name provided by user.
    Param(
        [Parameter(Mandatory=$true)] [String]$fixName
    )
    $newFixAppRoot = $scriptDir + '\' + $fixName
    Get-ChildItem -Recurse $newFixAppRoot | Where-Object {$_.Name -match "FixBase"} | Rename-Item -NewName {$_.Name.replace("FixBase", $fixName)}
    Get-Childitem $newFixAppRoot -Recurse | ?{ ! $_.PSIsContainer } |Select-Object -Expand Fullname | ForEach-Object { (Get-Content $_) -Replace "FixBase", $fixName | Set-Content $_ }
    Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n-- INFO --`t" 
    Write-Host -ForegroundColor Green -BackgroundColor Black ("All necessary files have been renamed.")
}

function validateFixName{
    # Make sure name provided starts with "Fix" and if it doesn't prepend it.
    Param(
        [Parameter(Mandatory=$true)] [String]$userResponse
    )
    $userResponse = $userResponse.Trim()
    if($userResponse.StartsWith("Fix")){
        $validatedName = $userResponse
    }
    else{
        $validatedName = "Fix" + $userResponse
    }
    return $validatedName
}

function createNewFixProcess{
    # Main workflow for creating new fix.
    Param(
        [Parameter(Mandatory=$true)] [String]$userResponse
    )
    $validatedName = validateFixName $userResponse
    $newFixAppRoot = $scriptDir + '\' + $validatedName
    if(!(Test-Path -Path $newFixAppRoot )){
        createRootDirectory $newFixAppRoot
        copyFixBase $newFixAppRoot
        renameFix $validatedName
        Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n-- INFO --`t" 
        Write-Host -ForegroundColor Green -BackgroundColor Black ("Process Complete: `"" + $validatedName + "`" has been created")   
    }
    else{
        Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Red "`n-- ERROR --`t" 
        Write-Host -ForegroundColor Red -BackgroundColor Black ("There is already a fix named `"" + $validatedName + "`" located at `"" + $scriptDir + "`"")
        promptUserForNewName
    }
}

if($User -eq "Default"){
    createNewFixProcess $Name        
}
else{
    $Env:NewFixName = $Name
    Write-Host "User Config Options Have not been enabled yet. Please run script again without passing argument: User."
}
