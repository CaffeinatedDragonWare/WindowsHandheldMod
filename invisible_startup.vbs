Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

'Path to check files
Steam = objShell.ExpandEnvironmentStrings("%UserProfile%\Videos\steam_startup.bat")
Playnite = objShell.ExpandEnvironmentStrings("%UserProfile%\Videos\playnite_startup.bat")
Custom = objShell.ExpandEnvironmentStrings("%UserProfile%\Videos\startup.bat")

'Check if file exists
If objFSO.FileExists(Steam) Then
    objShell.Run Steam, 0, True
Elseif objFSO.FileExists(Playnite) Then
    objShell.Run Playnite, 0, True
Elseif objFSO.FileExists(Custom) Then
    objShell.Run Custom, 0, True
Else
    WScript.Echo "No start up file found. Please download a startup.bat file and put it in your videos folder."
End if