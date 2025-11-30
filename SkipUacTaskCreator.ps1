$t=2
$prog_name="SkipUacTaskCreator"



$installdir= [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$installdir= [System.IO.Path]::GetDirectoryName($installdir)



$option=@{}

#$optionscontent = Get-Content -Path "$installdir\config.ini" | ForEach-Object {
#$parts = $_ -split "="
#$option[$parts[0].Trim()]=$parts[1].Trim()
#}

$optionscontent = Get-Content -Path "$installdir\config.ini" | ForEach-Object {
    $parts = $_ -split "=", 2
    if ($parts.Count -eq 2) {
        $option[$parts[0].Trim()] = $parts[1].Trim()
    }
}




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






$suffix=$option["SuffixName"]
$lnkpath=$option["LnkPath"]


$runpath="$installdir\Tasks-runfiles"

if ($lnkpath -eq "default") {
	$lnkpath=$runpath
} else{New-Item -Path $lnkpath -ItemType Directory -Force > $null}





New-Item -Path $runpath -ItemType Directory -Force > $null


function makerunfile{
	
$batcontent = "C:\Windows\System32\schtasks.exe /run /tn `"$prog_name\$($file_name)`""
$batcontent | Set-Content -Path "$($runpath)\$file_name.bat"


	
	
$WScriptShell = New-Object -ComObject WScript.Shell
if ($option["OutputToSameFolder"] -eq 1) {
if ($option["AppendSuffixToLnk"] -ge 1) {	
$shortcut = $WScriptShell.CreateShortcut("$($file_path.DirectoryName)\$file_name $suffix.lnk")	} else {$shortcut = $WScriptShell.CreateShortcut("$($file_path.DirectoryName)\$file_name..lnk")}
}else { 
if ($option["AppendSuffixToLnk"] -eq 2) {$shortcut = $WScriptShell.CreateShortcut("$lnkpath\$file_name $suffix.lnk") } 
else{ $shortcut = $WScriptShell.CreateShortcut("$lnkpath\$file_name.lnk") }
}

$shortcut.TargetPath = "$($runpath)\$($file_name).bat"
$shortcut.WindowStyle = 7
if ($option["IconStyle"] -eq 1) {
	start-process "$installdir\Badgify.exe" -Argumentlist "`"$($File_path)`"" 
	#start-sleep -s 0.2
	$shortcut.IconLocation= "$installdir\icon\$file_name IconTEMP.ico"
} else{$shortcut.IconLocation= "$installdir\icon.ico"}
$shortcut.Save()

	
	
if (($option["LnkInBothBaseAndOutputFolder"] -eq 1) -and ($option["OutputToSameFolder"] -eq 1)) {
if ($option["AppendSuffixToLnk"] -eq 2) {	$shortcut = $WScriptShell.CreateShortcut("$lnkpath\$file_name $suffix.lnk") }else { $shortcut = $WScriptShell.CreateShortcut("$lnkpath\$file_name.lnk")}
	}
$shortcut.TargetPath = "$($runpath)\$($file_name).bat"
$shortcut.WindowStyle = 7
if ($option["IconStyle"] -eq 1) {
	start-process "$installdir\Badgify.exe" -Argumentlist "`"$($File_path)`"" 
	#start-sleep -s 0.2
	$shortcut.IconLocation= "$installdir\icon\$file_name IconTEMP.ico"
} else{$shortcut.IconLocation= "$installdir\icon.ico"}
$shortcut.Save()	

}


$message2 = @{
    "it" = "Benvenuto!"
    "en" = "Welcome!"
    "es" = "¡Bienvenido!"
    "fr" = "Bienvenue !"
    "de" = "Willkommen!"
    "pt" = "Bem-vindo!"
}



write $message2[$lang]




if ($param.count -eq 1) {

$file=$param
$file_path=Get-Item($file)
$file_ext=$file_path.extension
$file_name=[System.IO.Path]::GetFileNameWithoutExtension($file)

$t=1

$time=(Get-Date).AddMinutes(-30).ToString("HH:mm")
$user=$env:USERNAME



if ($file_ext -eq ".lnk"){
$File=(New-Object -COM WScript.Shell).CreateShortcut($file_path)
}

if ($file_ext -eq ".lnk"){ 
if ($file.Arguments -ne ''){
$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -Argument "$($File.Arguments)" -WorkingDirectory "$($File.WorkingDirectory)"
}else{$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -WorkingDirectory "$($File.WorkingDirectory)"}
}else{ $Action = New-ScheduledTaskAction -Execute "`"$($file)`""}
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable:$false
Register-ScheduledTask -Action $Action -Settings $Settings -TaskName "$prog_name\$($file_name)" -User "$($user)" -RunLevel Highest -Force


makerunfile
}elseif ($param.count -gt 1){ 

if ($param.count -lt 3){
#$t=0.5*$param.count
}#	else{$t=2}

$t=2

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
$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -Argument "$($File.Arguments)" -WorkingDirectory "$($File.WorkingDirectory)"
}else{$Action = New-ScheduledTaskAction -Execute "`"$($File.Targetpath)`"" -WorkingDirectory "$($File.WorkingDirectory)"}
}else{ $Action = New-ScheduledTaskAction -Execute "`"$($file)`""}
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable:$false
Register-ScheduledTask -Action $Action -Settings $Settings -TaskName "$prog_name\$($file_name)" -User "$($user)" -RunLevel Highest -Force


makerunfile

}#end for

}#end $param.count -gt 1


$message3 = @{ 
    "it" = "Fatto!" 
    "en" = "Done!" 
    "es" = "¡Hecho!"
    "fr" = "Fait !"
    "de" = "Fertig!"
    "pt" = "Feito!"
}


write $message3[$lang]

Remove-item "c:\temp\$($prog_name)_temp.txt"

start-sleep -s $t

if ($option["RemoveGeneratedIcon"] -eq 1){ 



for($i=0;$i -lt $($param.count);$i++){
$file=$param[$i]
$file_path=Get-Item($file)
$file_ext=$file_path.extension
$file_name=[System.IO.Path]::GetFileNameWithoutExtension($file)
#Remove-Item -path "$($installdir)\icon\$file_name IconTEMP.ico" -Force
[System.IO.File]::Delete("$installdir\icon\$file_name IconTEMP.ico")
}

}


