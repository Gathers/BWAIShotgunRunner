function DownloadAndInstall {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Url,
        [Parameter()]
        [string] $Arguments,
        [Parameter()]
        [string] $Filename
    )
    if (Test-Path "download\$Filename") {
        Start-Process -FilePath "download\$Filename" -ArgumentList "$Arguments" -Wait -Passthru
    } else {
        Invoke-WebRequest "$Url" -OutFile "..\$Filename"
        Start-Process -FilePath "..\$Filename" -ArgumentList "$Arguments" -Wait -Passthru
    }
}

DownloadAndInstall -Url 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -Filename 'VC_redist.x64.exe' -Arguments '/passive'
DownloadAndInstall -Url 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -Filename 'VC_redist.x86.exe' -Arguments '/passive'
DownloadAndInstall -Url 'https://javadl.oracle.com/webapps/download/AutoDL?BundleId=246263_165374ff4ea84ef0bbd821706e29b123' -Filename 'jre-8u331-windows-i586.exe' -Arguments '/s'

#Install 7zip module needed to extract BWAIShotgun
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name 'PSGallery' -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted
Install-Module -Name 7Zip4Powershell -Force
#-SkipPublisherCheck

#download and extract BWAIShotgun
if (Test-Path 'download\bwaishotgun.7z') {
    Expand-7Zip -ArchiveFileName 'download\bwaishotgun.7z' -TargetPath '..\shotgun' -Password shotgun
} else {
    Invoke-WebRequest 'https://github.com/Bytekeeper/BWAIShotgun/releases/download/v0.5/bwaishotgun.7z' -OutFile '..\bwaishotgun.7z'
    Expand-7Zip -ArchiveFileName '..\bwaishotgun.7z' -TargetPath '..\shotgun' -Password shotgun
}

#Copy starcraft zip to BWAIShotgun download folder if file exists
if (Test-Path 'download\scbw_bwapi440.zip') {
    New-Item '..\shotgun\download' -ItemType Directory
    Copy-Item 'download\scbw_bwapi440.zip' -Destination '..\shotgun\download'
}

Copy-Item shotgun.toml ..\shotgun\shotgun.toml
#run BWAIShotgun once without a map set to make it expand startcraft zip
Start-Process -FilePath '..\shotgun\BWAIShotgun.exe' -Wait -Passthru
Copy-Item game.toml ..\shotgun\game.toml
