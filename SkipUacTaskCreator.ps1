#$runpath=""
$t=2
$prog_name="SkipUacTaskCreator"


$installdir= [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$installdir= [System.IO.Path]::GetDirectoryName($installdir)

$runpath="$installdir\Tasks-runfiles"



$lang=(Get-Culture).Name
if ($lang -match '-') { $lang = $lang.Split('-')[0]}
$message =@{
"it" = "Seleziona i file e inviali a SkipUacTaskCreator tramite il menu contestuale, trascinandoli su Accumulator.exe, oppure avvia SkipUacTaskCreator-window.exe e trascina i file nella finestra!"
"en" = "Select the files and send them to SkipUacTaskCreator via the context menu, by dragging them onto Accumulator.exe, or launch SkipUacTaskCreator-window.exe and drag the files into the window!"
"es" = "¡Selecciona los archivos y envíalos a SkipUacTaskCreator mediante el menú contextual, arrastrándolos a Accumulator.exe, o inicia SkipUacTaskCreator-window.exe y arrastra los archivos a la ventana!"
"fr" = "Sélectionnez les fichiers et envoyez-les à SkipUacTaskCreator via le menu contextuel, en les faisant glisser sur Accumulator.exe, ou lancez SkipUacTaskCreator-window.exe et faites glisser les fichiers dans la fenêtre !"
"de" = "Wähle die Dateien aus und sende sie an SkipUacTaskCreator über das Kontextmenü, indem du sie auf Accumulator.exe ziehst, oder starte SkipUacTaskCreator-window.exe und ziehe die Dateien in das Fenster!"
"pt" = "Selecione os arquivos e envie-os para o SkipUacTaskCreator pelo menu de contexto, arrastando-os para o Accumulator.exe, ou inicie o SkipUacTaskCreator-window.exe e arraste os arquivos para a janela!"
}
 if (!$message.ContainsKey($Lang)){ $lang= "en" }



if (-not(Test-Path("c:\temp\$($prog_name)_temp.txt"))){
write $message[$lang]
start-sleep -s 5
exit
}else{
$param=Get-Content -Path "c:\temp\$($prog_name)_temp.txt"
if ($param -eq $null){
write $message[$lang]
start-sleep -s 5

exit	
    }
  }





New-Item -Path $runpath -ItemType Directory -Force > $null


function makerunfile{
	
$batcontent = "C:\Windows\System32\schtasks.exe /run /tn `"$prog_name\$($file_name)`""
$batcontent | Set-Content -Path "$($runpath)\$file_name.bat"


	
	
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$runpath\$file_name.lnk")
$shortcut.TargetPath = "$($runpath)\$($file_name).bat"
$shortcut.WindowStyle = 7
$shortcut.IconLocation= "$installdir\icon.ico"
$shortcut.Save()
	
	
	
}


write "Welcome!"




if ($param.count -eq 1) {

$file=$param
$file_path=Get-Item($file)
$file_ext=$file_path.extension
$file_name=[System.IO.Path]::GetFileNameWithoutExtension($file)



$time=(Get-Date).AddMinutes(-30).ToString("HH:mm")
$user=$env:USERNAME



if ($file_ext -eq ".lnk"){
$File=(New-Object -COM WScript.Shell).CreateShortcut($file_path)
}

if ($file_ext -eq ".lnk"){ 
if ($file.Arguments -ne ''){
$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -Argument "$($File.Arguments)"
}else{$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`""}
}else{ $Action = New-ScheduledTaskAction -Execute "`"$($file)`""}
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable:$false
Register-ScheduledTask -Action $Action -Settings $Settings -TaskName "$prog_name\$($file_name)" -User "$($user)" -RunLevel Highest -Force


makerunfile
}elseif ($param.count -gt 1){ 



for($i=0;$i -lt $($param.count);$i++){

$file=$param[$i]
$file_path=Get-Item($file)
$file_ext=$file_path.extension
$file_name=[System.IO.Path]::GetFileNameWithoutExtension($file)



if ($file_ext -eq ".lnk"){

$file=(New-Object -COM WScript.Shell).CreateShortcut($file_path)
}


$time=(Get-Date).AddMinutes(-30).ToString("HH:mm")
$user=$env:USERNAME

	


if ($file_ext -eq ".lnk"){ 
if ($file.Arguments -ne ''){
$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -Argument "$($File.Arguments)"
}else{$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`""}
}else{ $Action = New-ScheduledTaskAction -Execute "`"$($file)`""}
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable:$false
Register-ScheduledTask -Action $Action -Settings $Settings -TaskName "$prog_name\$($file_name)" -User "$($user)" -RunLevel Highest -Force


makerunfile

}#end for

}#end $param.count -gt 1


write "Done!"

Remove-item "c:\temp\$($prog_name)_temp.txt"
start-sleep -s $t

