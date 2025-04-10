#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Accumulator
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_ProductName=SkipUacTaskCreator, SkipUacTaskOneClickCreator, SUTOCC
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.1
#AutoIt3Wrapper_Res_CompanyName=roob-p (author)
#AutoIt3Wrapper_Res_LegalCopyright=roob-p (author)
#AutoIt3Wrapper_Res_LegalTradeMarks=roob-p (author)
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <MsgBoxConstants.au3>
#include <Process.au3>

$prog="SkipUacTaskCreator"
$tempfile="c:\temp\SkipUacTaskCreator_temp.txt"

$ris= _Singleton("Accumulator",1)

if $ris<>0 then
	;$txt=fileopen("C:\temp\battemp.txt",2)
	$txt=fileopen($tempfile,2)
	for $i = 1 To $cmdline[0]
	FileWriteline($txt,$cmdline[$i])
	next
	fileclose($txt)
	while $ris<>0
		sleep(150)
	$numberOfAppInstances = ProcessList(_ProcessGetName(@AutoItPID))
	$numberOfAppInstances = $numberOfAppInstances[0][0]
	If $numberOfAppInstances > 1 Then
		else
		$ris=0
	endif

	wend
	;$txt=fileopen("C:\temp\battemp.txt",0)
	$txt=fileopen($tempfile,0)
	$fr=fileread($txt)
	fileclose($fr)
	;;msgbox("","",$fr,2)
	sleep(150)
	shellexecute("c:\windows\system32\schtasks", '/run /tn "SkipUacTaskCreator\main\SkipUacTaskCreator_MAIN"')

else


$numberOfAppInstances = ProcessList(_ProcessGetName(@AutoItPID))
$numberOfAppInstances = $numberOfAppInstances[0][0]

$lock=$numberOfAppInstances


while 1
if _singleton("copy",1)<>0 then

$txt=fileopen($tempfile,1)

for $i = 1 To $cmdline[0]


FileWriteline($txt,$cmdline[$i])
next
fileclose($txt)
exit

EndIf



wend


endif

