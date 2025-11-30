#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Badge
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_ProductName=Badgify-SkipUacTaskCreator
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.2
#AutoIt3Wrapper_Res_CompanyName=roob-p (author)
#AutoIt3Wrapper_Res_LegalCopyright=roob-p (author)
#AutoIt3Wrapper_Res_LegalTradeMarks=roob-p (author)
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPIIcons.au3>
#include <WinAPIGdi.au3>
#include <WinAPIIcons.au3>
#include <WinAPIShellEx.au3>
#include <WinAPIRes.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <FileConstants.au3>


$size=1.75

$file=$cmdline[1]
Local $aPath = _PathSplit($CmdLine[1],"","","","")
Local $sName = $aPath[3]
$aa=0


if ($aPath[4]=".lnk") then
$filee=FileGetShortcut($file)
$file=$filee[0]

endif

_GDIPlus_Startup()


$fileH = _WinAPI_ShellExtractIcon ( $file, 0, 256, 256)
$iconH = _WinAPI_LoadImage(0, @ScriptDir & "\icon.ico", $IMAGE_ICON, 256, 256, $LR_LOADFROMFILE)



if ($fileH=0) then

	;FileCopy(@ScriptDir & "\icon.ico", @ScriptDir & "\"&$sName&" IconTEMP.ico",1)
	DirCreate(@ScriptDir & "\icon")
	FileCopy(@ScriptDir & "\icon.ico", @ScriptDir & "\icon\"&$sName&" IconTEMP.ico",1)
	exit
	endif



$hfileH=_GDIPlus_BitmapCreateFromHICON ($fileH)
$hiconH=_GDIPlus_BitmapCreateFromHICON ($iconH)


$hGraphics = _GDIPlus_ImageGetGraphicsContext($hfileH)
_GDIPlus_GraphicsDrawImageRect($hGraphics,$hiconH, 256-(256/$size)+23/$size,256-256/$size,256/$size,256/$size)

local $hfileHx[4]
local $hfileHxx[4]

$hfileHx[0]=_GDIPlus_ImageResize($hFileH,16,16)
$hfileHx[1]=_GDIPlus_ImageResize($hFileH,32,32)
$hfileHx[2]=_GDIPlus_ImageResize($hFileH,48,48)
$hfileHx[3]=_GDIPlus_ImageResize($hFileH,256,256)

$hfileHxx[0]=_GDIPlus_HICONCreateFromBitmap($hFileHx[0])
$hfileHxx[1]=_GDIPlus_HICONCreateFromBitmap($hFileHx[1])
$hfileHxx[2]=_GDIPlus_HICONCreateFromBitmap($hFileHx[2])
$hfileHxx[3]=_GDIPlus_HICONCreateFromBitmap($hFileHx[3])



;_WinAPI_SaveHICONToFile(@ScriptDir & "\"&$sName&" IconTEMP.ico",$hFileHxx)
DirCreate(@ScriptDir & "\icon")
_WinAPI_SaveHICONToFile(@ScriptDir & "\icon\"&$sName&" IconTEMP.ico",$hFileHxx)



_GDIPlus_ImageDispose($hFileH)
_GDIPlus_ImageDispose($hiconH)
_GDIPlus_ImageDispose($hGraphics)
_WinAPI_DestroyIcon($fileH)
_WinAPI_DestroyIcon($iconH)
