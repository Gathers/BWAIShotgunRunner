# BWAIShotgunRunner
Script and basic instructions for running BWAIShotgun in a Windows Sandbox.

For installing Windows Sandbox, see https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview

Automatic setup:
Edit HostFolder in botsandbox.wsb, then you can just double-click it to open a Sandbox that automatically runs the setup-script.

Manual setup: (if you don't want to use the botsandbox.wsb shortcut)
1. Open a new Windows Sandbox.
2. Copy the folder "setup" to the desktop. (the folder, not just the contents)
3. Right-click "setup.ps1" and "Run with PowerShell".

The script will download BWAIShotgun, install dependencies and a Java 8 JRE. When it is done you should be able to run BWAIShotgun from the shotgun folder. BWAIShotgun will handle downloading Starcraft.
