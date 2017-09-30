#persistent
#singleinstance force
#NoEnv
;#warn
SetWorkingDir %A_ScriptDir%
SendMode Input
SetMouseDelay, -1
SetKeyDelay, -1
SetDefaultMouseSpeed, 0
SetControlDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

	#include Socket.ahk
	#include Time.ahk
	
	global riftopen := [287, 190, 457, 386, "\pngs\rift-open.png", 93, 118 , 65,2] 
	global cancelgrift := [1055, 152, 1209, 265, "\pngs\supercancel.png", 122, 84 , "*50 *TransBlack",1] 
	global menu_start_disabled := [223, 471, 414, 560, "\pngs\menu_disabled_side2_small.png", 32, 59 , 30,2] 
	global leavegame := [81, 454, 405, 514, "\pngs\newleavegame.png", 38, 42, 50,2] ; tbm funciona para logoutonmenu
	global logoutonmenu :=  [81, 454, 405, 514, "\pngs\newleavegame.png", 38, 42, 50,2] 
	global acceptgr := [780, 793, 1156, 864, "\pngs\newacceptgr.png", 70, 43 , 60,1]
	global leaveparty := [1618, 878, 1672, 925, "\pngs\newleaveparty.png", 16, 32 , 60,3]
	global leaveparty2 := [701, 567, 1216, 726, "\pngs\newleaveparty2.png", 410, 23 , 60,1] ; tbm funciona para inactivity
	global inactivity := global inactivity := [743, 388 1200, 550, "\pngs\newinactivity.png", 401,43 , "*50 *TransBlack",1]
	global grcomplete := [722, 674, 872, 911, "\pngs\grcomplete.png" ,49 ,150,60,1]
	global leavegame1 := [286, 254, 375, 355, "\pngs\newleavegame.png", 36, 42, 35, 2]
	global leavegame2 := [286, 314, 375, 405, "\pngs\newleavegame.png", 36, 42, 35, 2]
	global leavegame3 := [286, 368, 375, 454, "\pngs\newleavegame.png", 36, 42, 35, 2]
	global leavegame4 := [286, 424, 375, 510, "\pngs\newleavegame.png", 36, 42, 35, 2]
	global leavegame5 := [286, 469, 375, 564, "\pngs\newleavegame.png", 36, 42, 35, 2]
	
	
	global teleport1 := [57 , 228,2]
	global teleport2 := [162, 373,2]
	global acceptclick := [961, 805,1]
	global cancelbutton := [1061, 375,1]
	global leavegamebutton := [291, 484,2]
	global leavepartybutton := [1690, 900,2]
	global leaveparty2button := [860, 660,2]
	global disconnectedbutton := [ 962 , 661,1 ]
	global cancelgriftbutton := [ 962 , 883, 1 ]
	
	ConvertClick(teleport1)
	ConvertClick(teleport2)
	ConvertClick(acceptclick)
	ConvertClick(cancelbutton)
	ConvertClick(leavegamebutton)
	ConvertClick(leavepartybutton)
	ConvertClick(leaveparty2button)
	ConvertClick(disconnectedbutton)
	ConvertClick(cancelgriftbutton)
	
	
	ConvertCoordinates(grcomplete)
	ConvertCoordinates(riftopen)
	ConvertCoordinates(menu_start_disabled)
	ConvertCoordinates(logoutonmenu)
	ConvertCoordinates(cancelgrift)
	ConvertCoordinates(inactivity)
	ConvertCoordinates(acceptgr)
	ConvertCoordinates(leavegame)
	ConvertCoordinates(leavegame1)
	ConvertCoordinates(leavegame2)
	ConvertCoordinates(leavegame3)
	ConvertCoordinates(leavegame4)
	ConvertCoordinates(leavegame5)
	ConvertCoordinates(leaveparty)
	ConvertCoordinates(leaveparty2)
	
	global paused := 0
	WriteLog("Start Script Executing")
	
	
	Iniread, serverport, variables.ini, Settings, ServerPort
	Iniread, logpath, variables.ini, Settings, LogPath
	
	
	global myServer := new SocketTCP()
	myServer.onAccept := Func("OnTCPAccept")
	myServer.bind("addr_any", serverport)
	myServer.listen()
	WriteLog("Server listening")
	
	Gui, Add, Text, x17 y114 w80 h20 +Center, Log File
	Gui, Add, GroupBox, x7 y4 w570 h170 , Settings
	Gui, Add, Edit, x113 y34 w107 h18 vserverport , %serverport%
	Gui, Add, Edit, x112 y115 w305 h18 vlogpath , %logpath%
	Gui, Add, Button, x387 y234 w110 h40 gdoexit, Hide
	Gui, Add, Button, x97 y234 w110 h40 gdostart, Change Value
	Gui, Add, Text, x444 y117 w39 h17 +Center, Browse
	Gui, Add, Text, x17 y34 w80 h20 +Center, Port
	Gui, Add, Button, x501 y114 w54 h19 gdochoosefile , Choose
	; Generated using SmartGUI Creator for SciTE
	Gui, Show, w604 h320, MultiBot Server
	return

	dochoosefile:
		FileSelectFile, logfileselected
		GuiControl,Text, logpath, %logfileselected%
	return
    
	doexit:
		Gui, destroy
	return
    
	dostart:
		Gui, submit, NoHide
		Iniread, oldserverport, variables.ini, Settings, ServerPort
		Iniwrite, %serverport%, variables.ini, Settings, ServerPort
		Iniwrite, %logpath%, variables.ini, Settings, LogPath		
		if(oldserverport != serverport){
			reload
		}
	return
    

	OnTCPAccept(this)
	{
		global myClient := this.accept()
		myClient.onRecv := func("OnTCPRecv")
		myClient.onDisconnect := func("OnTCPDisconnect")
		WriteLog("connection accepted")
	}
	
	OnTCPDisconnect(this)
	{
		WriteLog("TCP Client Disconected")
	}
			
	
	F12::
		myClient.sendText("dh have urushi")
	return
	

	OnTCPRecv(this)
	{
		Thread, NoTimers, true
		global controlText := this.recvText()	
		;;ToolTip, controlText = %controlText% , 850 , 980, 16
		IfNotInString, controlText, ping
		{
			WriteLog("message received: " controlText)
		}
		
	   IfInString, controlText, go to menu
	   {
	    
		if (exited = 0 and receivedfailed = 0){
			SendInput, {F4 down}
			Sleep 50
			SendInput, {F4 up}
			Sleep 1000
			failed1 := 1
			receivedfailed := 1
			WriteLog("go to menu received: pause and leave")
			exited := 1
			chatstep := "blank"
			Gosub, dopause
			WinActivate, Diablo III
			 WriteLog("logout attempt")
			 Gosub, LeaveGame
			 WriteLog("focus diablo")
			 Gosub, FocusDiablo
		 }
	   }

	   	IfInString, controlText, pause
		{		
			WriteLog("pause received")
			if (paused = 0){	
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 pause received: pausing")
			}
		}
		IfInString, controlText, cancelgrift
		{		
			WriteLog("received message cancelgrift")			
			if (paused = 0){
				paused :=0
				SendInput, {F6}
				WriteLog("F6 cancelgrift:pausing")
			}			
			Gosub, CancelGRift
		}
		
		IfInString, controlText, beginsequence
		{	
			WriteLog("received beginsequence: starting")
			WinGetTitle, InitialWin, A
			global RosWintitle := InitialWin
			WriteLog("starting rosb")
			Gosub, StartRos
			WriteLog("gosub init")
			Gosub, initial
			
					
		}
		
		IfInString, controlText, riftacceptbutton ;; means gr entered (he accepted the gr) 
		{
			if(paused = 1){
				Sleep 100
				Gosub, FocusDiablo	
				WriteLog("riftacceptbutton received: gr entered")	
				entered := 0
				orek := 0
				wentback := 0
				uiclosed := 0
				uiopened := 0
				didurshi := 0
				bosskilled := 0
				talkingui := 0
				completed := 0	
				gotourshi := 1	
				otherurshi := 0	
				receivedfailed := 0	
				pausestart := 0
				idled := 0
				idledtries := 0
				exited := 0	
				didurshi := 0
				talkingui := 0
				completed := 0
				otherurshi := 0	
				gotourshi := 1
				failed1 := 0
				failed2 := 0
				idled := 0
				idledtries := 0
				exited := 0
				receivedfailed := 0	
				paused := 0				
				Gosub, FocusDiablo				
				WriteLog("riftacceptbutton received: send cancelgrift")				
				if (paused = 1){
					paused :=0
					SendInput, {F6}
					WriteLog("F6 riftacceptbutton received: unpausing")
				}
			}
			else{
				entered := 0
				uiclosed := 0
				uiopened := 0
				didurshi := 0
				bosskilled := 0
				talkingui := 0
				completed := 0	
				gotourshi := 1	
				otherurshi := 0	
				receivedfailed := 0	
				pausestart := 0
				idled := 0
				idledtries := 0
				exited := 0	
				WriteLog("riftacceptbutton received: but paused = 0")
			}
				
		}
		
		   
		IfInString, controlText, start
		{			
			WriteLog("start received")
			if (paused = 1){	
				paused := 0
				SendInput, {F6}	
				WriteLog("F6 start received:starting")
			}
		}
		
		
		IfInString, controlText, idlecounter
		{
			didurshi := 0
			talkingui := 0
			completed := 0
			otherurshi := 0	
			gotourshi := 1
			GR := 0
			failed1 := 0
			failed2 := 0
			idled := 0
			idledtries := 0
			exited := 0
			receivedfailed := 0	
			paused := 0
			WriteLog("received idle reset")
		}

		IfInString, controlText, startros
		{
			WriteLog("startros received routine")
			Gosub, initial
			Gosub, DoUnBlockInput
			Sleep 1000
			if (paused = 1){							
				paused := 0
				SendInput, {F6}	
				WriteLog("startros received F6 unpausing")
			}			
			;Gosub, StartRos	
			WriteLog("startros received routine finished")
		}
		
		IfInString, controlText, close ui
		{
			SendInput, l	
			WriteLog("close ui receivbed")
		}
		
		IfInString, controlText, force init 0
		{
			pausestart := 0		
			WriteLog("force init 0 received")
		}
		
		IfInString, controlText, stop
		{			
			if (paused = 0){
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 stop received")
			}
		}
		
		IfInString, controlText, necro did urushi
		{
			WriteLog("necro did urushi received")
			otherurshi := 1		
		}
		
		
		if (gotourshi = 1 and didurshi = 0){
			IfInString, controlText, necro have urushi
				{	
					WriteLog("necro have urushi received")
					gotourshi := 0
					if (paused = 0){							
						paused := 1
						SendInput, {F6}	
						WriteLog("F6 pausing")
					}		
					WriteLog("clicking teleport")
					Sleep 500
					c1 := teleport1[1]
					c2 := teleport1[2]
					MouseMove, %c1% , %c2%
					Sleep 50
					SendInput, {Click right down}
					Sleep 50
					SendInput, {Click right up}
					Sleep 200
					c1 := teleport2[1]
					c2 := teleport2[2]
					MouseMove, %c1% , %c2%	
					Sleep 50
					SendInput, {Click down}
					Sleep 50
					SendInput, {Click up}
					Sleep 5000	
					if (paused = 1){	
						paused := 0
						SendInput, {F6}	
						WriteLog("F6 unpausing")
					}
					WriteLog("necro have urushi routine finished")
				
			}
		}	
		Thread, NoTimers, false
	}
	
	pingchecker:
	;	if(newTcp.sendText("Ping") = 0 and idled = 0)
	;	{
	;		Sleep 200
	;		if(newTcp.sendText("Ping") = 0 and idled = 0)
	;		{
	;			Sleep 200
	;			if(newTcp.sendText("Ping") = 0 and idled = 0)
	;			{
	;		
	;			 failed2 :=1 ;nao procurar pelo menu enabled normal
	;			 failed1 := 1 ;nao procurar por disconnection
	;			 WriteLog("TCP Disconnect ping detected paused: " paused)
	;			 if (paused = 0){
	;				paused := 1
	;				SendInput, {F6}               
	;				WriteLog("pausing")
	;			 }
	;			 WriteLog("logout attempt")
	;			 Gosub, FocusDiablo
	;			 Gosub, LeaveGame
	;			 Gosub, GoAlone
	;			}
	;		}
	;	}
	return
	
	
	\::	
		
			SetTimer, imagereader, off
			SetTimer, logreader, off
			SetTimer, idlewatcher, off
			SetTimer, pingchecker, off
			WriteLog("timers off key pressed")
		
	return	
	
	
	initial:

		global doleave := 0
		global paused := 0
		global justentered:=0				
		global doonce := 1
		global doonce2 := 2
		global didurshi := 0
		global gotourshi := 1
		global talkenter :=1
		global bosskilled := 0
		global talkingui := 0
		global completed := 0
		global accept := 0
		global otherurshi := 0		
		global failed1 := 0
		global receivedfailed := 0
		global pausestart := 1
		global GR := 0
		global exited := 1	
		global idled := 0
		global idledtries := 0
		global interactUi := 0
		global blockedinput := 0
		WriteLog("running init: starting timers")
		
		SetTimer, imagereader, 1,1
		SetTimer, logreader, 1,2
		SetTimer, idlewatcher, 30000
		SetTimer, pingchecker, 30000

	return


	Tail(k,file)   ; Return the last k lines of file
	{
	   Loop Read, %file%
	   {
		  _i_ := Mod(A_Index,k)
		  L%_i_% = %A_LoopReadLine%
	   }
	   L := L%_i_%
	   Loop % k-1
	   {
		  IfLess _i_,1, SetEnv _i_,%k%
		  _i_--      ; Mod does not work here
		  L := L%_i_% "`n" L
	   }
	   Return L
	}
	
	imagereader:
		Thread, Interrupt, 0
	;;menu start
		if (failed1 = 1 and talkenter = 1)
		{
			pathpng := A_ScriptDir . menu_start_disabled[5]
			scale :=  "*w" . menu_start_disabled[6] . " *h" . menu_start_disabled[7]
			ImageSearch , MenuDisabledX, MenuDisabledY, menu_start_disabled[1], menu_start_disabled[2], menu_start_disabled[3], menu_start_disabled[4], *23 %scale% %pathpng%
			if(MenuDisabledX > 0){
				Gosub, DoUnBlockInput
				Sleep 1000
				if (paused = 1){			
					paused := 0
					SendInput, {F6}	
					WriteLog("F6 unpausing: imonmenu detect imagereader")
				}	
				WriteLog("imagereader menu disabled")
				StringSend := "imonmenu"
				Gosub, SenderText
				talkenter := 0
				Gosub, initial
			}

		}
	
	
	
		;;rift complete
		if (didurshi =1){
			pathpng := A_ScriptDir . grcomplete[5]
		    scale :=  "*w" . grcomplete[6] . " *h" . grcomplete[7]
            ImageSearch , GRCompleteX, GRCompleteY, grcomplete[1], grcomplete[2], grcomplete[3], grcomplete[4], *50 %scale% %pathpng%
			
			if (GRCompleteX > 0) ;and GRCompleteY > 0 and completed = 0)
			{		
				WriteLog("gr complete detected")
				sleep 2000
				SendInput, l
				receivedfailed := 0
				GR := 0
				failed1 := 0
				failed2 := 0
			}
		}
		
		;;accept found:do cancel
			if (paused =1){
				pathpng := A_ScriptDir . acceptgr[5]
				scale :=  "*w" . acceptgr[6] . " *h" . acceptgr[7]
				ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
			    if (AcceptRiftX > 0){
					 WriteLog("accept found: trying to click cancel")
					 Loop, 500 {
					 ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
						if (AcceptRiftX > 0){
							c1 := cancelgriftbutton[1]
							c2 := cancelgriftbutton[2]
							Click %c1% , %c2%    
							WriteLog("accept found: clicked cancel")
							Sleep 50
							Break
						}
				    }
				}
			}
		
		
	;;riftacceptbutton (open ui - to go rift)
   
		if (GR = 0){
			pathpng := A_ScriptDir . riftopen[5]
			scale :=  "*w" . riftopen[6] . " *h" . riftopen[7]
			ImageSearch , RiftOpenX, RiftOpenY, riftopen[1], riftopen[2], riftopen[3], riftopen[4], *50 %scale% %pathpng%
		    if (RiftOpenX > 0){
				WriteLog("riftacceptbutton imagesearch")
				GR := 1
				idled := 0
				accept := 1
			}
		}
	   
   
   ;;cancel omni
    if(paused = 1){
		pathpng := A_ScriptDir . cancelgrift[5]
		scale :=  "*w" . cancelgrift[6] . " *h" . cancelgrift[7]
		ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 %scale% %pathpng%
		if (CancelGRiftX > 0){
			Loop, 500 {   
				if (CancelGRiftX > 0){
					Gosub, FocusDiablo            
					WriteLog("Cancel Grift found imagereader: clicking it")
					c1 := cancelbutton[1]
					c2 := cancelbutton[2]
					Click %c1% , %c2%        
					Break
				}
		    }
	    }
		;if (blockedinput = 1 and failed1 = 1) {
		;	pathpng := A_ScriptDir . logoutonmenu[5]
		;	scale :=  "*w" . logoutonmenu[6] . " *h" . logoutonmenu[7]
		;	ImageSearch , MenuCreditsEX, MenuCreditsEY, logoutonmenu[1], logoutonmenu[2], logoutonmenu[3], logoutonmenu[4], *50 %scale% %pathpng%				
		;	if(MenuCreditsEX > 0){		
		;		WriteLog("imagereader logout on esc")
		;		Gosub, DoUnBlockInput
		;		Sleep 500
		;		SendInput, {Esc}			
		;		Gosub, DoBlockInput
		;		Sleep 1000
		;	}
		;}
    }
   
   
	;disconnected or timedout - ok - 
	if (blockedinput = 1 and failed1 = 1){
		pathpng := A_ScriptDir . inactivity[5]
		scale :=  "*w" . inactivity[6] . " *h" . inactivity[7]
		options := inactivity[8]
		ImageSearch , DiscX, DiscY, inactivity[1], inactivity[2], inactivity[3], inactivity[4], %options% %scale% %pathpng%
		if(DiscX > 0){
			WriteLog("imagereader disconnected or timedout")
			Gosub, DoUnBlockInput
			Sleep 500
			Click %DiscX% , %DiscY%
			Gosub, DoBlockInput
		}
	}
	 
	 
	return
	
	str_getTail(_Str, _LineNum = 1)
	{
		StringGetPos, Pos, _Str, `n, R%_LineNum%
		StringTrimLeft, _Str, _Str, % ++Pos
		Return _Str
	}
	
	
	logreader:	
		Thread, Interrupt, 0
		;;urshi UI detect
		;;urshi UI detect	
		;FileRead, file, C:\Users\slayn\Documents\RoS-BoT\Logs\logs.txt
		;global chatstep := str_getTail(file, 25)
		
		global chatstep := Tail(20,logpath)		
		
		
		IfInString, chatstep, InteractWithUiAndWaitFor 
		{	
			IfNotInString, chatstep, RiftAcceptButton
			{	
			LogLock := 1
			interactUi := 1
			}
		}
		
		
		IfInString, chatstep, Running urshi...
		{	
			if (didurshi = 0){
				LogLock := 1				
				Gosub, FocusDiablo
				didurshi := 1
				bosskilled := 1
				gotourshi := 0
				objlook := 1
				talkingui := 1
				failed2 := 0
				paused := 0
				receivedfailed := 0
				pausestart := 1
				GR := 0
				WriteLog("running urshi... detected: send dh have urushi")
				StringSend := "dh have urushi"
				Gosub, SenderText
			}	
		}
		
		IfInString, chatstep, Upgrade gem
		{	
			if (didurshi = 0){
				LogLock := 1			
				Gosub, FocusDiablo
				didurshi := 1
				bosskilled := 1
				gotourshi := 0
				objlook := 1
				talkingui := 1
				failed2 := 0
				receivedfailed := 0
				pausestart := 1
				GR := 0
				paused := 0
				WriteLog("upgrade gem detected: send dh have urushi")
				StringSend := "dh have urushi"
				Gosub, SenderText
			}	
		}


		if(talkingui = 1 and didurshi = 1){
			IfInString, chatstep, Urshi to disappear
					{
					LogLock := 1
					talkingui := 0	
					StringSend := "dh have urushi and dh did urshi"	
					Gosub, SenderText					
					paused := 0
					failed2 := 0	
					GR := 0
					receivedfailed := 0
					pausestart := 1
			}
		}
		
		
	;open rift pause
	;IfInString, chatstep, start a loop
	;{			
	;	receivedfailed := 0
	;	if (pausestart = 1 and paused = 0){
	;		LogLock := 1	
	;		pausestart := 0					
	;		if (paused = 0){			
	;			paused := 1
	;			SendInput, {F6}	
	;			WriteLog("F6 from start a loop")
	;		}	
	;		WriteLog("star a loop detected: send iamready")	
	;		Sleep 2000
	;		StringSend := "iamready"
	;		Gosub, SenderText
	;		
	;	}
	;}
	
	IfInString, chatstep, vendor loop done
	{			
		receivedfailed := 0
		if (pausestart = 1 and paused = 0 ){
			LogLock := 1	
			pausestart := 0					
			if (paused = 0){			
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 from vendorloop")
			}	
			Sleep 3000
			WriteLog("vendor loop done detected: send iamready")
			StringSend := "iamready"
			Gosub, SenderText
		}
	}
	
	
	
	;IfInString, chatstep, worldId
	;{
	;	WriteLog("worldId: rift is running")
	;}
	
	IfInString, chatstep, next rift in different
	{	   
	   if (failed1 = 0 and receivedfailed = 0 and exited = 0){
	    SendInput, {F4 down}
		Sleep 50
		SendInput, {F4 up}
		Sleep 1000
	    LogLock := 1
		WriteLog("next rift in different: f6 logout")
		;BlockInput, on
		Gosub, dopause
		failed1 := 1
		failed2++
		chatstep := "blank"
		StringSend := "failure"	
		Gosub, SenderText
		WriteLog("logout attempt")
		Gosub, LeaveGame
	   }
	}

	;IfInString, chatstep, disconnection
	;{
	;   
	;   if (failed1 = 0 and receivedfailed = 0 and exited = 0){
	;   
	;	  failed1 := 1
	;	  failed2 := 1
	;	  WriteLog("disconnection detected: f7 and send failure")
	;	  chatstep := "blank"
	;	  SendInput, {F7}  
	;	  WinActivate, Diablo III
	;	  Gosub, FocusDiablo
	;didurshi := 1	
	;	  newTcp2.sendText("failure")	
	;	  Gosub, FocusDiablo
	;	  Gosub, LeaveGame
	;	  Gosub, FocusDiablo
	;   }
	;}
	
	
	;IfInString, chatstep, RiftAcceptButton
	;{	
	;	if (GR = 0){
	;		WriteLog("riftacceptbutton chatstep")
	;		GR := 1
	;		failed1 := 0
	;		exited := 0
	;		interactUi := 1
	;		if (paused = 0){
	;			WriteLog("chatstep riftacceptbutton:pausing")
	;			paused :=1
	;			SendInput, {F6}
	;		}
	;		WriteLog("sending riftacceptbutton")
	;		SendText("riftacceptbutton")
	;	}
	;}

	LogLock := 0
	
	return
	
		
	
	StartRos:
		i := 0
		while(i < 50){
			WinActivate, %RosWintitle%
			WinGetTitle, ActiveWin, A
			if (ActiveWin = RosWintitle){
				SendInput , {Space}				
				Break
			}
			i++
		}
	return
	
	FocusDiablo:
		i := 0
		while(i < 50){
			WinActivate, Diablo III			
			WinGetTitle, ActiveWindow, A
			if (ActiveWindow = "Diablo III"){	
				Break
			}
			i++
		}
	return
	
	WriteLog(Text){   
	   global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	   FileAppend,
	   (
	   %A_YYYY%-%A_MM%-%A_DD%(%A_Hour%h%A_Min%m%A_Sec%sec) %Text% p: %paused%

	   ), Multilog.txt
	   return
	}
	
	idlewatcher:
	   CurrenTime := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	   secondsElapsed := Time(CurrenTime,LastLogWrite,"s")
	   if (secondsElapsed > 800 and failed1 = 0){  
		failed1 := 1
		failed2++
		WriteLog("idlewatcher: f7 and send failure")
		chatstep := "blank"
		if(paused =0){
			paused := 1
			SendInput, {F6}
			WriteLog("next rift in different: f6 pausing")
		}  
		WinActivate, Diablo III		  
		Gosub, FocusDiablo
		StringSend := "failure by idlewatcher"
		Gosub, SenderText
		Gosub, LeaveGame
		Gosub, FocusDiablo
	   }	   
	   if (secondsElapsed > 800 and failed2 = 3 ){
			WriteLog("idlewatcher com failed1: goingalone")
			Gosub, LeaveGame
			Gosub, GoAlone
	   }
	return

		
	LeaveGame:
		doleave := 1
		MouseMove, 0, 0
		Loop, 16 {
		    WriteLog("LEave game found: clicking leave game try:" a_index)
			Gosub, FocusDiablo
			SendInput, {Esc}
			Sleep 1000
			pathpng := A_ScriptDir . leavegame1[5]
			scale :=  "*w" . leavegame1[6] . " *h" . leavegame1[7]
			ImageSearch , LeaveGame1X, LeaveGame1Y, leavegame1[1], leavegame1[2], leavegame1[3], leavegame1[4], *40 *TransBlack %scale% %pathpng%
			ImageSearch , LeaveGame2X, LeaveGame2Y, leavegame2[1], leavegame2[2], leavegame2[3], leavegame2[4], *40 *TransBlack %scale% %pathpng%
			ImageSearch , LeaveGame3X, LeaveGame3Y, leavegame3[1], leavegame3[2], leavegame3[3], leavegame3[4], *40 *TransBlack %scale% %pathpng%
			ImageSearch , LeaveGame4X, LeaveGame4Y, leavegame4[1], leavegame4[2], leavegame4[3], leavegame4[4], *40 *TransBlack %scale% %pathpng%
			ImageSearch , LeaveGame5X, LeaveGame5Y, leavegame5[1], leavegame5[2], leavegame5[3], leavegame5[4], *40 *TransBlack %scale% %pathpng%
			if(LeaveGame1X > 0 and LeaveGame2X > 0 and LeaveGame3X > 0 and LeaveGame4X > 0 and LeaveGame5X > 0 ){
				c1 := leavegamebutton[1]
				c2 := leavegamebutton[2]				
				MouseMove %c1% , %c2%
				Sleep 50
				SendEvent, {Click down}
				Sleep 50
				SendEvent, {Click up}
				Sleep 50
				SendInput, {F4 down}
				Sleep 50
				SendInput, {F4 up}
				Gosub, DoBlockInput
				exited := 1
				WriteLog("LEave game found: clicking leave game and blocking input")
				Break
			}
			Sleep 200
		}
		if (doleave = 1){ ;couldnt leave
			SendInput, {F4 down}
			Sleep 50
			SendInput, {F4 up}
			Sleep 1000
			Gosub, dounpause
		}
	return
		
	return

	CancelGRift:
		Sleep 100
		SendInput, l
		Sleep 100
		pathpng := A_ScriptDir . cancelgrift[5]
		scale :=  "*w" . cancelgrift[6] . " *h" . cancelgrift[7]
		ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 %scale% %pathpng%
		if (CancelGRiftX > 0){
			Loop, 200 {	
				ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 %scale% %pathpng%
					if (CancelGRiftX > 0){
						Gosub, FocusDiablo	
						WriteLog("Cancel Grift found: clicking it")
						c1 := cancelbutton[1]
						c2 := cancelbutton[2]
						Click %c1% , %c2%		
						if (paused = 0){
							paused := 1
							SendInput, {F6}
							WriteLog("F6 pausing cancelbutton")
						}
						Break
					}
			}
		}
	return


		GoAlone:
		 idled := 0
	   Sleep 3000
		Gosub, DoUnBlockInput
		Sleep 2000		
	   WriteLog("waiting for menu to pop")
		i := 0
	   Loop, 200 {
		Sleep 40
		pathpng := A_ScriptDir . menu_start_disabled[5]
		scale :=  "*w" . menu_start_disabled[6] . " *h" . menu_start_disabled[7]
		ImageSearch , MenuDisabledX, MenuDisabledY, menu_start_disabled[1], menu_start_disabled[2], menu_start_disabled[3], menu_start_disabled[4], *35 %scale% %pathpng%
		  if (MenuDisabledX > 0 or MenuEnabledX > 0){
				Sleep 3000
				Break                  
		  }
	   }
		pathpng := A_ScriptDir . leaveparty[5]
		scale :=  "*w" . leaveparty[6] . " *h" . leaveparty[7]
		ImageSearch , LeavePartyX, LeavePartyY, leaveparty[1], leaveparty[2], leaveparty[3], leaveparty[4], *50 %scale% %pathpng% 
		  if (LeavePartyX >0){
			i := 0
			 Loop, 150 {
				WriteLog("leaving party")
				c1 := leavepartybutton[1]
				c2 := leavepartybutton[2]
				Click %c1% , %c2%
				Sleep 200
				pathpng := A_ScriptDir . leaveparty2[5]
				scale :=  "*w" . leaveparty2[6] . " *h" . leaveparty2[7]
				ImageSearch , LeaveParty2X, LeaveParty2Y, leaveparty2[1], leaveparty2[2], leaveparty2[3], leaveparty2[4], *50 %scale% %pathpng%
				if(LeaveParty2X > 0)
				{
					c1 := leavepartybutton2[1]
					c2 := leavepartybutton2[2]
					Click %c1% , %c2%
				   Sleep 1000
				   Break
				}
				Sleep 200
			 }
		  }
	   if (paused = 1){
		  paused := 0
		  SendInput, {F6}
		  WriteLog("F6 Idled too many detected: unpausing alone")
	   }   
	   WriteLog("Exiting after resume alone")
	   Sleep 1000
	   idled := 0
	   ExitApp	
	return
	
	AcceptGr:
		WriteLog("going to AcceptGr")
		c1 := acceptclick[1]
		c2 := acceptclick[2]
		Click %c1% , %c2%
		Sleep 1000
		pathpng := A_ScriptDir . acceptgr[5]
		scale :=  "*w" . acceptgr[6] . " *h" . acceptgr[7]
		ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
		if(AcceptRiftX > 0){
		  Loop, 200{
		  ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
			  if (AcceptRiftX > 0){
				c1 := acceptclick[1]
				c2 := acceptclick[2]
				Click %c1% , %c2%
				Break
			  }
		  }
		}
	return

	SenderText:
	   WriteLog("SendText: " StringSend)
	   sent := myClient.sendText(StringSend)
	   if (sent > 0)
	   {
		   WriteLog("sent: " StringSend " status: " sent)
	   }
	   else
	   {
		 Loop, 35 {
		   Sleep 200
		   WriteLog("send retrying: " StringSend " retry attempt: " a_index "status: " sent)               
		   sent := myClient.sendText(StringSend)
		   if (sent > 0){
			 WriteLog("retry send successful: " StringSend " retry: " a_index "status: " sent)
			 Break
		   }
		 }
		 if(sent = 0){
		   WriteLog("retry send FAILED: " StringSend " retries: " a_index "status: " sent)
		 }
		}
   return
   
    DoBlockInput:
		if(blockedinput = 0){
		  blockedinput := 1	
		  WriteLog("blocking")		  
		  BlockInput, on
		}
	return

	DoUnBlockInput:
		if(blockedinput = 1){
		  blockedinput := 0
		  BlockInput, off
		  WriteLog("unblocking")	
		}   
	return

	ConvertCoordinates(ByRef Array)
	{
		WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
		D3ScreenResolution := DiabloWidth*DiabloHeight

		Position := Array[9]

	;Pixel is always relative to the middle of the Diablo III window
		If (Position == 1){
			Array[1] := Round(Array[1]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
			Array[3] := Round(Array[3]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
		}

	  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
		If Else (Position == 2 || Position == 4){
			Array[1] := Round(Array[1]*(DiabloHeight/1080), 0)
			Array[3] := Round(Array[3]*(DiabloHeight/1080), 0)
		}

		;Pixel is always relative to the right side of the Diablo III window
		If Else (Position == 3){
			Array[1] := Round(DiabloWidth-(1920-Array[1])*DiabloHeight/1080, 0)
			Array[3] := Round(DiabloWidth-(1920-Array[3])*DiabloHeight/1080, 0)
		}

		Array[2] := Round(Array[2]*(DiabloHeight/1080), 0)
		Array[4] := Round(Array[4]*(DiabloHeight/1080), 0)
		
		Array[6] :=  Round(Array[6]*(DiabloWidth/1920), 0)
		Array[7] :=  Round(Array[7]*(DiabloHeight/1080), 0)
	
	
	}
	
	ConvertClick(ByRef Array)
	{
		WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
		D3ScreenResolution := DiabloWidth*DiabloHeight

		Position := Array[3]

		;Pixel is always relative to the middle of the Diablo III window
	  If (Position == 1){
		Array[1] := Round(Array[1]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
		}

	  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
	  If Else (Position == 2 || Position == 4){
			Array[1] := Round(Array[1]*(DiabloHeight/1080), 0)
		}

		;Pixel is always relative to the right side of the Diablo III window
		If Else (Position == 3){
			Array[1] := Round(DiabloWidth-(1920-Array[1])*DiabloHeight/1080, 0)
		}

		Array[2] := Round(Array[2]*(DiabloHeight/1080), 0)
	}
	
	dopause:
		if (paused = 0){
			paused := 1
			SendInput, {F6 down}
			Sleep 50
			SendInput, {F6 up}
			WriteLog("F6 pausing gosub")
		}
	return
	
	dounpause:
		if (paused = 1){
			paused := 0
			SendInput, {F6 down}
			Sleep 50
			SendInput, {F6 up}
			WriteLog("F6 pausing gosub")
		}
	return