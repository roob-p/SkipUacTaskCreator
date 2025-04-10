$prog_name="SkipUacTaskCreator"



$installdir= [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$installdir= [System.IO.Path]::GetDirectoryName($installdir)

$user=$env:username


$lang=(Get-Culture).Name
if ($lang -match '-') { $lang = $lang.Split('-')[0]}
$message =@{
"it" = "Da ora i task generati tramite 'Invia a' nel menù contestuale verranno creati senza alcun prompt UAC!"
"en" = "From now, tasks generated via 'Send to' in the context menu will be created without any UAC prompt!"
"es" = "¡A partir de ahora, las tareas generadas mediante 'Enviar a' en el menú contextual se crearán sin ningún aviso de UAC!"
"fr" = "Désormais, les tâches générées via 'Envoyer vers' dans le menu contextuel seront créées sans aucune invite UAC !"
"de" = "Von nun an werden Aufgaben, die über 'Senden an' im Kontextmenü erstellt werden, ohne UAC-Aufforderung erstellt!"
"pt" = "De agora em diante, as tarefas geradas via 'Enviar para' no menu de contexto serão criadas sem qualquer aviso do UAC!"
}
if (!$message.ContainsKey($Lang)){ $lang= "en" }



$file=(New-Object -ComObject WScript.Shell).CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$file_exe=[System.IO.Path]::GetFileName($file.targetpath)

if ($file_exe -eq "Accumulator.exe"){
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$shortcut.TargetPath = "$installdir\Accumulator v. admin required.exe"
#$shortcut.IconLocation = "C:\Windows\System32\imageres.dll,73"
$shortcut.IconLocation= "$installdir\icon.ico"
$shortcut.Save()
write $message[$lang]
start-sleep -s 2
}
elseif($file_exe -eq "Accumulator v. admin required.exe"){
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("C:\Users\$user\AppData\Roaming\Microsoft\Windows\SendTo\$($prog_name).lnk")
$shortcut.TargetPath = "$installdir\Accumulator.exe"
#$shortcut.IconLocation = "C:\Windows\System32\imageres.dll,73"
$shortcut.IconLocation= "$installdir\icon.ico"
$shortcut.Save()
write $message[$lang]
start-sleep -s 2
}



