/*
	ShapeRecog

	Copyright 2015 Avi Aryan

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	REFERNCES

	InkPicture - https://msdn.microsoft.com/en-us/library/windows/desktop/ms704450%28v=vs.85%29.aspx
*/



SetWorkingDir, % A_ScriptDir
SetBatchlines, -1
#SingleInstance, force
OnExit, end_it_all

;--------------------
;  G L O B A L S
;--------------------

global PROGNAME := "Shape Recog"
global PI := asin(1)*2
global PI2 := asin(1)
global drawspace, logs
global COORDS = Object()
global CORNS = Object()

global MSLOPE := 10, M
global DIST_APART := 80
global ACC = 20*PI/180
global TRIACC := 30*PI/180
global FVERTEXCT
;--------------------
;  L A S T   S T E P S
;--------------------

makeGUI()
Return

;----------------------
; S H A P E    D E T E C T I O N
;----------------------

detectCorners(){
	len := COORDS.maxIndex()
	CORNS := {}
	FVERTEXCT := 0

	M := MSLOPE
	if (len < 100)
		M := round( M * (len/100.0) )

	LMT := 20
	if (len < 100)
		LMT := round( LMT * (len/100.0) )

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
				FVERTEXCT++
			} else {
				if (ST){
					if ( (TOBJ.MaxIndex() > 3) && (TOBJ.MaxIndex() < LMT) )
						CORNS.Insert( TOBJ[ Round(TOBJ.maxIndex()/2) ] )
				}
				tobj := {}
				ST := 0
			}
		}
	}

	if (ST){
		if ( (TOBJ.MaxIndex() > 3) && (TOBJ.MaxIndex() < LMT) )
			CORNS.Insert( TOBJ[ Round(TOBJ.maxIndex()/2) ] )
	}

	; CORNS calculated. Now proceed
	for k,v in CORNS
		msgbox % "Vertex " V
}


detectShape(){
/*
0 = LINE
1 = TRIANGLE
2 = SQUARE
3 = RECTANGLE
4 = CIRCLE
*/
	k := CORNS.MaxIndex()
	if (!k)
		return circleOrLine()
	else if (k==1)
		return validateCircle() ;validate
	; now after LINE is resolved, validate figure
	if !validateFigure()
		return -1
	if (k == 2)
		return validateTriangle()
	else if (k == 3){
		z := quadOrTriangle()
		if (z==1)
			return validateTriangle()
		else
			return SquareOrRect()
	} else if (k == 4)
		return SquareOrRect()
	else
		return -1
}

quadOrTriangle(){
	static A30 := asin(1)/3
	static A70 := asin(1)/1.25
	;fslope := calcSlope(COORDS[1+M], COORDS[1])
	fslope := calcSlope(CORNS[1], COORDS[1])
	lv := ObjhasValue(CORNS[3])
	;lslope := calcSlope(COORDS[lv+M], CORNS[3])
	lslope := calcSlope(COORDS[COORDS.maxIndex()], CORNS[3])

	if (calcAngle(lslope, fslope) < A30)
		return 1
	else if (calcAngle(lslope, fslope) > A70)
		return 3
	else
		return -1
}

SquareOrRect(){
	; in 3 vertex sq , the starting point will be the fourth point
	return 2
}

circleOrLine(){
	percent := FVERTEXCT / (COORDS.maxIndex()-2*M)
	if (percent > 0.7) ; generally this is seen
		return 4
	else if (percent < 0.2)
		return 0
	else
		return -1
}

validateCircle(){
	x := circleOrLine()
	if (x<4) ; if line or invalid
		return -1
	else return 4
}

validateFigure(){
	; The function will see if figure is closed or not
	; lp := COORDS[ COORDS.MaxIndex() ]
	; fp := COORDS[1]
	; z := distance(lp, fp)
	; D := (M/MSLOPE * DIST_APART)
	; if (z>D)
	; 	return 0
	; else return 1
	return 1
}

calcAngle(slope1, slope2){

	if (slope2 == "INF"){
		if (slope1 != "INF")
			Z := abs( PI2 - atan(slope1) )
		else Z := 0.000
	} else if (slope1 == "INF"){
		Z := abs(PI2-atan(slope2))
	} else
		Z := abs( atan( (slope2 - slope1) / (1 + slope2*slope1) ) )

	if (Z>PI2) ; obtuse angle
	{
		Z := PI - Z
		msgbox it is
	}
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

	Gui, 1:new
	Gui, 1:Default
	Gui, Font, s20, Consolas
	Gui, Add, Text, x5 y5, % PROGNAME
	Gui, Font, s14
	Gui, Add, ActiveX, xp y+20 w400 h400 vdrawspace, msinkaut.InkPicture.1
	Gui, Add, Picture, x+10 yp w400 h400 voutput,
	Gui, Font, s10
	Gui, Add, Text, x+20 yp h20, % "LOGS"
	Gui, Add, Edit, xp y+0 w200 h380 vlogs +ReadOnly +VScroll
	Gui, Font, s14
	Gui, Add, Button, x5 y+10 gclear, Clear
	;Gui, Add, Button, x+20 yp gdetect, Detect

	drawspace.AutoRedraw := 1
	ComObjConnect(drawspace, drawspace_events)

	Gui, Show, w1060, % PROGNAME
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
}

detect(){
	showMsg("`nDetection Starting ...")
	showMsg("`nPoints recorded : " COORDS.MaxIndex())
	detectCorners()
	showMsg("Corners Found : " CORNS.MaxIndex())
	x := detectShape()
	showMsg("Shape Detected As : " resolveShapeId(x))
}

showMsg(msg){
	Gui, 1:submit, NoHide
	GuiControlGet, logs
	GuiControl,, logs, % logs "`n" msg
	ControlSend, Edit1, ^{End}, % PROGNAME  " ahk_class AutoHotkeyGUI"
}

class drawspace_events {
	MouseMove(button, shift, px, py, cancel){
		if (GetKeyState("LButton", "P")){
			if ( ObjhasValue(px "-" py) == 0 ){
				;Tooltip, % "x " px "`ny " py "`n" COORDS.maxIndex(),,, 2
				COORDS.Insert(px "-" py)
			}
		}
	}

	Stroke(cursor, stroke, cancel){ ; after a stroke is drawn
		detect()
		COORDS := {}
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
#include lib\triangle.ahk