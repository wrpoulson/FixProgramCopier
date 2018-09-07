[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)][string]$Name
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$baseFixAppRoot = $scriptDir + '\Fix.BaseApp'

function createRootDirectory {
    Param(
        [Parameter(Mandatory=$true)]  [String]$newFixAppRoot
    )
    # Create root directory for new fix app. Calling 
    New-Item -ItemType directory -Path $newFixAppRoot
    Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n`n-- INFO --`t" 
    Write-Host -ForegroundColor Green -BackgroundColor Black ("Created Fix Application Root Directory: " + $newFixAppRoot)
}

function copyFixBase {
    Param(
        [Parameter(Mandatory=$true)]  [String]$newFixAppRoot
    )
    # Copy contents from Fix.BaseApp to root directory of new fix app.
    Copy-Item -Force -Recurse -Verbose ($baseFixAppRoot + "\*") -Destination $newFixAppRoot
    Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n`n-- INFO --`t" 
    Write-Host -ForegroundColor Green -BackgroundColor Black ("Base Files Have Been Copied To: " + $newFixAppRoot)    
}

function promptUserForNewName{
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "`n`nWould you like to try another name? `nEnter [Y] to try another fix application name, any other entry will end script execution.`n"
    $userResponse = Read-Host
    if($userResponse.ToUpper().Trim() -eq "Y"){
        Write-Host -ForegroundColor Black -BackgroundColor Green "`n`nEnter new fix name: "
        $userResponse = Read-Host
        createNewFixProcess $userResponse
    }
    else{
        Write-Host -ForegroundColor Black -BackgroundColor Red "`n-- EXITING --`n" 
    }
}

function renameFix{
    Param(
        [Parameter(Mandatory=$true)]  [String]$validatedName
    )
    Write-Host "Rename Fix " + $validatedName
    # solution -- file name, contents
    # csproj -- file name, contents
    # program.cs -- contents
    # prop.assemblyinfo -- assembly title, assembly product
    # .vs -- folder name for project
    # Implementations folder -- all file contents recursively
}

function validateFixName{
    Param(
        [Parameter(Mandatory=$true)]  [String]$userResponse
    )
    $userResponse = $userResponse.Trim()
    if($userResponse.StartsWith("Fix")){
        $validatedName = $userResponse
    }
    else{
        $validatedName = "Fix" + $userResponse
    }
    $newFixAppRoot = $scriptDir + '\' + $validatedName
    return $validatedName
}

function createNewFixProcess{
    Param(
        [Parameter(Mandatory=$true)]  [String]$userResponse
    )
    $validatedName = validateFixName $userResponse
    $newFixAppRoot = $scriptDir + '\' + $validatedName
    if(!(Test-Path -Path $newFixAppRoot )){
        createRootDirectory $newFixAppRoot
        copyFixBase $newFixAppRoot
        renameFix $validatedName
        Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Green "`n`n-- INFO --`t" 
        Write-Host -ForegroundColor Green -BackgroundColor Black ("Process Complete: `"" + $validatedName + "`" has been created")   
    }
    else{
        Write-Host -NoNewline -ForegroundColor Black -BackgroundColor Red "`n`n-- ERROR --`t" 
        Write-Host -ForegroundColor Red -BackgroundColor Black ("There is already a fix named `"" + $validatedName + "`" located at `"" + $scriptDir + "`"")
        promptUserForNewName
    }
}

createNewFixProcess $Name