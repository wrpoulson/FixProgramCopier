[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)][string]$Name
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$newFixAppRoot = $scriptDir + '\' + $Name
$baseFixAppRoot = $scriptDir + '\Fix.BaseApp'

function createRootDirectory {
    # Create root directory for new fix app. Calling 
    New-Item -ItemType directory -Path $newFixAppRoot
    Write-Host -ForegroundColor Black -BackgroundColor Green ('Created Fix Application Root Directory: ' + $newFixAppRoot)
}

function copyContents {
    # Copy contents from Fix.BaseApp to root directory of new fix app.
    Copy-Item -Force -Recurse -Verbose ($baseFixAppRoot + "\*") -Destination $newFixAppRoot
    Write-Host -ForegroundColor Black -BackgroundColor Green ('Base Files Have Been Copied To: ' + $newFixAppRoot)    
}

function replaceAllTheThings{
    # solution -- file name, contents
    # csproj -- file name, contents
    # program.cs -- contents
    # prop.assemblyinfo -- assembly title, assembly product
    # .vs -- folder name for project
    # Implementations folder -- all file contents recursively
}

function promptUserForNewName{

}

if(!(Test-Path -Path $newFixAppRoot )){
    createRootDirectory
    copyContents
}
else{
    # TODO: WRP - Add loop to allow them to choose a new name.
    Write-Host -ForegroundColor Black -BackgroundColor Red 'There is already a fix named ' + $Name + 'located at ' + $scriptDir
}

