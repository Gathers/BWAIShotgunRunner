#Create download folder if it doesn't exist
if (!(Test-Path 'download')) {
    New-Item 'download' -ItemType Directory
}

#Install 7zip module needed to extract BWAIShotgun
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name 'PSGallery' -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted
Install-Module -Name 7Zip4Powershell -Force
#-SkipPublisherCheck

#download and install VC2015 runtime (x64 for BWAIShotgun)
if (!(Test-Path 'download\VC_redist.x64.exe')) {
    Invoke-WebRequest 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile 'download\VC_redist.x64.exe'
}
Start-Process -FilePath 'download\VC_redist.x64.exe' -ArgumentList "/passive" -Wait -Passthru

#download and install VC2015 runtime (x86 for bot ZergHell)
if (!(Test-Path 'download\VC_redist.x86.exe')) {
    Invoke-WebRequest 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -OutFile 'download\VC_redist.x86.exe'
}
Start-Process -FilePath 'download\VC_redist.x86.exe' -ArgumentList "/passive" -Wait -Passthru

#download BWAIShotgun
if (!(Test-Path 'download\bwaishotgun.7z')) {
    Invoke-WebRequest 'https://github.com/Bytekeeper/BWAIShotgun/releases/download/v0.5/bwaishotgun.7z' -OutFile 'download\bwaishotgun.7z'
}

#extract BWAIShotgun
if (!(Test-Path 'download\bwaishotgun.exe')) {
    Expand-7Zip -ArchiveFileName 'download\bwaishotgun.7z' -TargetPath . -Password shotgun
}

Copy-Item _game.toml game.toml
Copy-Item _shotgun.toml shotgun.toml

#download and install java 8
if (!(Test-Path 'download\jre-8u331-windows-i586.exe')) {
    Invoke-WebRequest 'https://javadl.oracle.com/webapps/download/AutoDL?BundleId=246263_165374ff4ea84ef0bbd821706e29b123' -OutFile 'download\jre-8u331-windows-i586.exe'
}
Start-Process -FilePath 'download\jre-8u331-windows-i586.exe' -ArgumentList "/s" -Wait -Passthru
