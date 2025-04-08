$prog_name="SkipUacTaskCreator"



$installdir= [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$installdir= [System.IO.Path]::GetDirectoryName($installdir)

$user=$env:username

$file=(New-Object -ComObject WScript.Shell).CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$file_exe=[System.IO.Path]::GetFileName($file.targetpath)

if ($file_exe -eq "Accumulator.exe"){
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$shortcut.TargetPath = "$installdir\Accumulator v. admin required.exe"
#$shortcut.IconLocation = "C:\Windows\System32\imageres.dll,73"
$shortcut.IconLocation= "$installdir\icon.ico"
$shortcut.Save()
write "Da ora i task generati tramite 'Invia a' nel menù contestuale verranno creati senza alcun prompt UAC!" 
start-sleep -s 2
}
elseif($file_exe -eq "Accumulator v. admin required.exe"){
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$shortcut.TargetPath = "$installdir\Accumulator.exe"
#$shortcut.IconLocation = "C:\Windows\System32\imageres.dll,73"
$shortcut.IconLocation= "$installdir\icon.ico"
$shortcut.Save()
write "Da ora i task generati tramite 'Invia a' nel menù contestuale verranno creati senza alcun prompt UAC!" 
start-sleep -s 2
}



