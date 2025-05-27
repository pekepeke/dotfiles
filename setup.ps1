param (
    [switch]$Uninstall
)

$IsEnabledBackup = $false
$IgnoreFilePattern = "^setup"
$IgnoreFiles = @(
    "README.md"
    , ".config"
    , ".git"
    , ".gitmodules"
    , ".gitignore"
)
$CopyFiles = @{
    ".vimrc.personal.tmpl" = ".vimrc.personal";
    ".shrc.local.tmpl" = ".shrc.local";
    ".gitattributes_global.tmpl" = ".gitattributes_global";
}
$GitBash = $env:ProgramFiles + "\Git\bin\bash.exe"

Set-Location (Get-Item -Path $PSCommandPath).Directory
function MakeLink {
    param (
        [System.IO.FileSystemInfo]$file,
        [string]$linkBaseDir
    )
    if (-not (Test-Path $linkBaseDir)) {
        Write-Host ("## directory not found : " + $linkBaseDir)
        return
    }
    $fileName = $file.Name
    if ($IgnoreFiles -contains $fileName -or $fileName -match $IgnoreFilePattern) {
        Write-Host ("# skppped file: " + $fileName)
        return
    }
    $linkTo = (Join-Path $linkBaseDir $fileName)
    if (Test-Path $linkTo) {
        if ($IsEnabledBackup) {
            $backupFile = (Join-Path $linkBaseDir ".rc-org" $fileName)
            Write-Host ("# move file: " + $linkTo +  " -> " + $backupFile)
            Move-Item -Path $linkTo -Destination $backupFile
        } else {
            Write-Host ("# skipped already exists: " + $linkTo)
            return
        }
    }
    if ($file.Attributes -band [System.IO.FileAttributes]::Directory) {
        Write-Host ($file.FullName + " -> " + $linkTo)
        # New-Item -ItemType HardLink  -Target $file.FullName -Path $linkTo
        New-Item -ItemType SymbolicLink  -Target $file.FullName -Path $linkTo
    } elseif ($file.Attributes -band [System.IO.FileAttributes]::Archive) {
        Write-Host ($file.FullName + " -> " + $linkTo)
        New-Item -ItemType SymbolicLink -Target $file.FullName -Path $linkTo
    }
}
function CleanLink() {
    param (
        [System.IO.FileSystemInfo]$file,
        [string]$linkBaseDir
    )
    if (-not (Test-Path $linkBaseDir)) {
        Write-Host ("## directory not found : " + $linkBaseDir)
        return
    }
    $fileName = $file.Name
    if ($IgnoreFiles -contains $fileName -or $fileName -match $IgnoreFilePattern) {
        Write-Host ("# skppped file: " + $fileName)
        return
    }
    $linkTo = (Join-Path $linkBaseDir $fileName)
    if (-not (Test-Path $linkTo)) {
        Write-Host ("# already deleted: " + $linkTo)
        return
    }
    $linkToFile = Get-Item -Path $linkTo
    if ($linkToFile.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
    # if ($linkToFile.LinkType -ne "default") {
        Write-Host ("remove: " + $linkTo)
        Remove-Item -Path $linkTo
    }
}

$backupDir = Join-Path $HOME ".rc-org"
$configDir = Join-Path $HOME ".config"
if ($Uninstall) {
    Get-ChildItem ".config" | ForEach-Object {
        CleanLink $_ $configDir
    }
    Get-ChildItem | ForEach-Object {
        CleanLink $_ $HOME
    }
} else {
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { 
        Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
        exit 
    }

    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir
        $IsEnabledBackup = $true
    }
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir
        Write-Host ("# created : " + $configDir)
    }
    Get-ChildItem ".config" | ForEach-Object {
        MakeLink $_ $configDir
    }
    Get-ChildItem | ForEach-Object {
        MakeLink $_ $HOME
    }
    foreach ($src in $CopyFiles.Keys) {
        $toFile = Join-Path $HOME $CopyFiles[$src]
        if (-not (Test-Path $toFile)) {
            Write-Host("# copy file: " + $src + "->" + $toFile)
            Copy-Item -Path $src -Destination $toFile
        }
    }
    if (Test-Path $GitBash) {
        cmd /c $GitBash "~/.github-dotfiles/setup.sh"
    } else {
        Write-Error("# file not found: " + $GitBash)
    }
    Write-Host("# Finish : " + $PSCommandPath)
    Read-Host
}
