#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=SkipUacTaskCreator-Window
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_ProductName=SkipUacTaskCreator, SkipUacTaskOneClickCreator, SUTOCC
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.1
#AutoIt3Wrapper_Res_CompanyName=roob-p (author)
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WinAPIEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <MsgBoxConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <ButtonConstants.au3>
#include <Misc.au3>
#include <GUIConstants.au3>
#include <GUIListView.au3>
#include <WinAPISysWin.au3>
#include <WindowsConstants.au3>
#include <WinAPIGdi.au3>



$prog="SkipUacTaskCreator"
$tempfile="c:\temp\SkipUacTaskCreator_temp.txt"

Global $contextmenu = 0, $canc = 999

Global $__aGUIDropFiles = 0, $__hGUI = 0
$go=0



global $item[100];
global $itemcur[100];
for $u=0 to ubound($item)-1
	$item[$u]=""
	$itemcur[$u]=""
next


$xinis=15
$yinis=15

Global $hGui=GUICreate("SkipUacTaskCreator-window",640,480,-1,-1,$WS_SIZEBOX,bitor($WS_EX_TOPMOST,$WS_EX_ACCEPTFILES,$WS_EX_TRANSPARENT))

GUISetIcon(@ScriptDir&'\icon.ico',"",$hGui)

;$ctrl=GUICtrlCreateListView("Files:  ",0,0,540,400,$LVS_NOCOLUMNHEADER)
$ctrl=GUICtrlCreateListView("Files:  ",0,0,540,430,$LVS_REPORT)
GUICtrlSendMsg($ctrl, $LVM_SETCOLUMNWIDTH, 0, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetExtendedListViewStyle($ctrl,$LVS_EX_GRIDLINES)




guictrlsetstate($ctrl, $GUI_DROPACCEPTED)
guisetstate(@sw_show,$hGui)

GUIRegisterMsg($WM_DROPFILES, 'WM_DROPFILES')
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")



$it=0
$exist=0
$itemcur=""



$b1=GUICtrlCreateButton("",560,30,60,40,$BS_ICON)
GUICtrlSetImage($b1,@ScriptDir&'\graphics\icon.ico')
$b2=GUICtrlCreateButton('Cancella',560,240,60,40,$BS_ICON)
GUICtrlSetImage($b2,@ScriptDir&'\graphics\Delete.ico')


$tot=0
$z=0




$L=""
$sel=0
$find=0
$a=0

while 1


$k = Number(ControlListView ( "", "", $ctrl, "GetSelected" ))
$L=controlListView("","",$ctrl,"GetSelected",1)
$sel = StringSplit($L, "|",2)




	Switch GUIGetMsg()

			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $GUI_EVENT_DROPPED


				For $i = 1 To $__aGUIDropFiles[0]
					$exist=0


				for $j=0 to ubound($Item)-1

					if $Item[$j]=$__aGUIDropFiles[$i] Then

						$exist=1
						ExitLoop
					EndIf

					next


				if $exist=0 then
				if $it<ubound($item) then
				$Itemcur = GUICtrlCreateListViewItem($__aGUIDropFiles[$i], $ctrl)

				$Item[$it]=$__aGUIDropFiles[$i]


				$it+=1
				$tot+=1
				endif
				endif

				next


		Case $canc
			$go=1
		Delete()


		Case $b2
		$go=1
		Delete()

		Case $b1
			CreaTask()






	EndSwitch

if _IsPressed("2E") then
	$go=1
		Delete()
endif



wend







Func WM_DROPFILES($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $lParam
    Switch $iMsg
        Case $WM_DROPFILES
            Local Const $aReturn = _WinAPI_DragQueryFileEx($wParam)
            If UBound($aReturn) Then
                $__aGUIDropFiles = $aReturn
            Else
                Local Const $aError[1] = [0]
                $__aGUIDropFiles = $aError
            EndIf
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc







func Delete()


if $L <> '' then
	if $go=1 then
	_GUICtrlListView_DeleteItemsSelected($ctrl)

	for $m=0 to ubound($sel)-1
	$item[$sel[$m]]="CANC"
		next


		$temptot=$tot
		$a=0
		for $b=0 to $tot-ubound($sel)-1
		if $item[$a]<> "CANC" then
		$item[$b]=$item[$a]
		$a+=1
		else
		for $bb=$a to $tot-1
		if $item[$bb] <> "CANC" then
		$item[$b]=$item[$bb]
		$a=$bb+1
		exitloop
		endif
		next
		endif
		next

		for $t=$temptot-ubound($sel) to $tot-1
			$item[$t]="CANC"
		next

		if $tot>0 then
		$tot=$temptot-ubound($sel)
		endif

		if $it>0 then
		$it=$temptot-ubound($sel)
		endif






	endif

endif





$go=0
$canc=999
endfunc



func CreaTask()
	if $tot>0 then
$file=FileOpen($tempfile,2)
for $t=0 to $tot-1
	FileWriteLine($file,$item[$t])
next
FileClose($file)

shellexecute("c:\windows\system32\schtasks", '/run /tn "SkipUacTaskCreator\main\SkipUacTaskCreator_MAIN"')
sleep(2000)

while ProcessExists("SkipUacTaskCreator.exe")
	sleep(100)
	wend



winactivate($hGui)
$posGui=WinGetPos($hGui)
$sizeGui=WinGetClientSize($hGui)


SplashImageOn("Fatto!","C:\SkipUacTaskCreator\graphics\OK.bmp",150,100,$posGui[0]+$sizeGui[0]/2 - 75,$posGui[1]+$sizeGui[1]/2-50)




Local $hWnd = WinGetHandle("Fatto!")
_WinAPI_EnableWindow($hWnd, True)
Local $nStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
Local $exStyle =_WinAPI_GetWindowLong($hWnd, $GWL_EXSTYLE)
_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, $nStyle + $WS_SYSMENU)
_WinAPI_SetWindowLong($hWnd, $GWL_EXSTYLE,$exStyle + $WS_EX_TOPMOST)
_WinAPI_SetWindowPos($hWnd, $HWND_TOPMOST,0,0,0,0, $SWP_NOSIZE + $SWP_NOMOVE + $SWP_FRAMECHANGED)



$timer=TimerInit()



if $tot <100 then

while 1
if TimerDiff($timer)>2000 Then
	winclose($hWnd)
	exitloop
	endif

if not WinExists($hWnd) Then
exitloop
EndIf

wend
endif




	endif




EndFunc


Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
  #forceref $hWnd, $MsgID, $wParam
  Local $tagNMHDR = DllStructCreate("int;int;int", $lParam)
Local $code = DllStructGetData($tagNMHDR, 3)
   If _isPressed(02) then

$contextmenu = GUICtrlCreateContextMenu($ctrl)
$canc=GUICtrlCreateMenuItem("Cancella", $contextmenu)


   endif



  Return $GUI_RUNDEFMSG
endfunc





