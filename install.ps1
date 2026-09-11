$ErrorActionPreference = "Stop"

$Repository = "mkasaii16/codesweep-releases"
$InstallDirectory = Join-Path $env:LOCALAPPDATA "Programs\codesweep"
$Release = Invoke-RestMethod "https://api.github.com/repos/$Repository/releases/latest"
$ArchiveName = "codesweep-$($Release.tag_name)-windows-x64.zip"
$ChecksumName = "$ArchiveName.sha256"
$ArchiveUrl = ($Release.assets | Where-Object name -eq $ArchiveName).browser_download_url
$ChecksumUrl = ($Release.assets | Where-Object name -eq $ChecksumName).browser_download_url

if (-not $ArchiveUrl -or -not $ChecksumUrl) {
    throw "The latest release does not contain the Windows x64 package."
}

$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) "codesweep-install-$([guid]::NewGuid())"
New-Item -ItemType Directory -Path $TemporaryDirectory | Out-Null

try {
    $ArchivePath = Join-Path $TemporaryDirectory $ArchiveName
    $ChecksumPath = Join-Path $TemporaryDirectory $ChecksumName
    Invoke-WebRequest $ArchiveUrl -OutFile $ArchivePath
    Invoke-WebRequest $ChecksumUrl -OutFile $ChecksumPath

    $ExpectedHash = ((Get-Content $ChecksumPath -Raw).Trim() -split '\s+')[0]
    $ActualHash = (Get-FileHash $ArchivePath -Algorithm SHA256).Hash
    if ($ActualHash -ine $ExpectedHash) {
        throw "SHA-256 checksum verification failed."
    }

    New-Item -ItemType Directory -Force -Path $InstallDirectory | Out-Null
    Expand-Archive -Path $ArchivePath -DestinationPath $InstallDirectory -Force

    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $PathEntries = @($UserPath -split ";" | Where-Object { $_ })
    if ($PathEntries -notcontains $InstallDirectory) {
        $NewPath = ($PathEntries + $InstallDirectory) -join ";"
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    }

    Write-Host "codesweep $($Release.tag_name) installed in $InstallDirectory"
    Write-Host "Open a new terminal and run: codesweep --help"
}
finally {
    Remove-Item -Recurse -Force $TemporaryDirectory -ErrorAction SilentlyContinue
}
