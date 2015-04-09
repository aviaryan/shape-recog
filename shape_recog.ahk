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
; S H A P E    D E T E C T I O N
;----------------------

detectCorners(){
	len := COORDS.maxIndex()

	M := 10
	if (len < 100)
		M := round( M * (len/100.0) )

	static PI := asin(1)*2
	static ACC = 20*PI/180

	ST := 0, tobj := {}

	loop % len-M
	{
		if (A_index>M){
			cur := calcSlope( COORDS[A_index], COORDS[A_index-M] )
			pre := calcSlope( COORDS[A_index+M], COORDS[A_index] )

			Z := calcAngle(pre, cur)

			if ( Z > ACC ){
				tobj.Insert(COORDS[A_Index])
				ST := 1
			} else {
				if (ST){
					if ( (TOBJ.MaxIndex() > 3) && (TOBJ.MaxIndex() < 20) )
						CORNS.Insert( TOBJ[ Round(TOBJ.maxIndex()/2) ] )
				}
				tobj := {}
				ST := 0
			}
		}
	}

	if (ST){
		if ( (TOBJ.MaxIndex() > 3) && (TOBJ.MaxIndex() < 20) )
			CORNS.Insert( TOBJ[ Round(TOBJ.maxIndex()/2) ] )
	}

	; CORNS calculated. Now proceed
	for k,v in CORNS
		msgbox % "Vertex " V
}

calcAngle(slope1, slope2){
	static PI2 := asin(1)

	if (slope2 == "INF"){
		if (slope1 != "INF")
			Z := abs( PI2 - atan(slope1) )
		else Z := 0.000
	} else if (slope1 == "INF"){
		Z := abs(PI2-atan(slope2))
	} else
		Z := abs( atan( (slope2 - slope1) / (1 + slope2*slope1) ) )

	if (Z>PI2) ; obtuse angle
		Z := PI2*2 - Z
	return Z
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
	detectCorners()
	return
}

class drawspace_events {
	MouseMove(button, shift, px, py, cancel){
		if (GetKeyState("LButton", "P")){
			;px := Round(px/1.0) , py := Round(py/1.0)
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