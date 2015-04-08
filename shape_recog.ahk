SetWorkingDir, % A_ScriptDir
SetBatchlines, -1
#SingleInstance, force
OnExit, end_it_all

;--------------------
;  G L O B A L S
;--------------------

global PROGNAME := "Shape Recog"
global drawspace
global COORDS = Object()
global CORNS = Object()

;--------------------
;  L A S T   S T E P S
;--------------------

makeGUI()
Gui, Show, w860, % PROGNAME

Return

;----------------------
; E N D   A U T O E X E C U T E
;----------------------

shapeDetect(){
	len := COORDS.maxIndex()
	static M := 10
	static PI := asin(1)*2
	static ACC = 20*PI/180
	static PI2 := PI/2

	ST := 0

	loop % len
	{
		if (A_index>M){
			cur := calcSlope( COORDS[A_index], COORDS[A_index-M] )
			pre := calcSlope( COORDS[A_index+M], COORDS[A_index] )

			if (cur == "INF"){
				if (pre != "INF")
					Z := abs( PI2 - atan(pre) )
				else Z := 0.000
			} else if (pre == "INF"){
				Z := abs(PI2-atan(cur))
			} else
				Z := abs( atan( (cur - pre) / (1 + cur*pre) ) )

			if ( Z > ACC ){
				msgbox % ST "F" COORDS[A_index]
				ST := 1
			} else
				ST := 0
		}
	}

}

calcSlope(p1, p2){
	p2x := Substr(p2, 1, Instr(p2, "-")-1)
	p2y := Substr(p2, Instr(p2, "-")+1)
	p1x := Substr(p1, 1, Instr(p1, "-")-1)
	p1y := Substr(p1, Instr(p1, "-")+1)
	if (p1x == p2x)
		return "INF"
	else
		return (p2y-p1y)/(p2x-p1x)
}

;-----------------------
; G U I   S T U F F
;-----------------------

makeGUI(){
	global

	Gui, Font, s20, Consolas
	Gui, Add, Text, x5 y5, % PROGNAME
	Gui, Font, s14
	Gui, Add, ActiveX, xp y+20 w400 h400 vdrawspace, msinkaut.InkPicture.1
	Gui, Add, Picture, x+20 yp w400 h400 voutput,
	Gui, Add, Button, x5 y+10 gclear, Clear
	Gui, Add, Button, x+20 yp gdetect, Detect

	drawspace.AutoRedraw := 1
	ComObjConnect(drawspace, drawspace_events)
	return


GuiClose:
	gosub end_it_all
	return

clear:
	drawspace.InkEnabled := false
	drawspace.Ink.DeleteStrokes( drawspace.Ink.Strokes )
	drawspace.InkEnabled := true
	COORDS := Object()
	CORNS := Object()
	return

detect:
	shapeDetect()
	return
}

class drawspace_events {
	MouseMove(button, shift, px, py, cancel){
		if (GetKeyState("LButton", "P")){
			px := Round(px/1.0) , py := Round(py/1.0)
			if ( ObjhasValue(px "-" py) == 0 ){
				Tooltip, % "x " px "`ny " py "`n" COORDS.maxIndex(),,, 2
				COORDS.Insert(px "-" py)
			}
		}
	}
}



end_it_all:
	drawspace := ""
	ExitApp
	return

;--------------------------------
;       I N C L U D E S
;--------------------------------

#include lib\misc.ahk