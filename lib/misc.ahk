/*
	PROGRAM BASED FS
*/

resolveShapeId(ID){
	if (id == ID_LINE)
		return "LINE"
	else if (id == ID_TRI)
		return "TRIANGLE"
	else if (id == ID_SQ)
		return "SQUARE"
	else if (id == ID_RECT)
		return "RECTANGLE"
	else if (id == ID_CIR)
		return "CIRCLE"
	else if (id == ID_QUAD)
		return "INVALID (QUAD)"
	else if (id == ID_DIST)
		return "INVALID (DIST_ERROR)"
	else if (id == ID_OVAL)
		return "INVALID (OVAL)"
	else if (id < 0)
		return "INVALID"
}

distance(p1, p2){
	givePoints(p2, p2x, p2y)
	givePoints(p1, p1x, p1y)
	return Sqrt( (p2y-p1y)**2 + (p2x-p1x)**2 )
}

givePoints(p1, byref x1, byref y1){
	if (Instr(p1,"-")==1)
		sp := Instr(p1, "-", 0, 2)
	else
		sp := Instr(p1, "-")
	x1 := Substr(p1, 1, sp-1)
	y1 := Substr(p1, sp+1)
}

givePointsInv(p1, byref x1, byref y1){
	givePoints(p1, x1, y1)
	y1 := 400-y1
}

pIntersectStart(ByRef x, ByRef y){
	; http://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
	givePoints(COORDS[1], x1, y1)
	givePoints(CORNS[1], x2, y2)
	givePoints(CORNS[CORNS.maxIndex()], x3, y3)
	givePoints(COORDS[COORDS.maxIndex()], x4, y4)
	d := (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4)
	if (d==0){
		x = -1
		y = -1
		return
	}
	part1 := x1*y2 - y1*x2
	part2 := x3*y4 - y3*x4
	x := part1*(x3-x4) - (x1-x2)*part2
	x/=d
	y := part1*(y3-y4) - (y1-y2)*part2
	y/=d
}

pIntersectStartInv(Byref x, Byref y){
	pIntersectStart(x,y)
	y := 400-y
}

realATan(x){
	; returns ATan() in range 0-180 degrees (0-pi radians)
	z := ATan(x)
	if (z<0)
		return PI2 + PI2 + z
	else
		return z
}

angleAtVertex(p1){
	pc := p1
	pos := ObjhasValue(pc)
	pf := COORDS[pos + M]
	pb := COORDS[pos - M]
	return angleFromPoints(pb, pc, pf)
}

angleAtVertexALAS(v_id){ ; Aliases the effect of small slopes, makes use of vertices nicely
	if (v_id == 1)
		fp := COORDS[1]
	else
		fp := CORNS[v_id-1]
	if (v_id == CORNS.maxIndex())
		lp := COORDS[COORDS.maxIndex()]
	else
		lp := CORNS[v_id+1]
	return angleFromPoints(fp, CORNS[v_id], lp)
}

angleFromPoints(pb, pc, pf){
	vf := MakeVector(pc, pf)
	vb := MakeVector(pc, pb)
	return anglefromVector(vf, vb)
}

anglefromVector(vf, vb){
	modside := ModVector(vf) * ModVector(vb)
	modfull := (vf[1]*vb[1]) + (vf[2]*vb[2])
	costheta := modfull / modside
	costheta := costheta>1 ? 1 : (costheta<-1 ? -1 : costheta)
	return acos( costheta )
}

validateAngle(a){
	return a>ACC ? a : -100
}

calcSlope(p1, p2){
	givePoints(p1, p1x, p1y)
	givePoints(p2, p2x, p2y)
	if (p1x == p2x)
		return "INF"
	else
		return (p2y-p1y)/(p2x-p1x)
}

MakeVector(p1, p2){
	; remember p1 is tail, p2 is head
	; NOTE that coordinate axes are not same here - upper y is 0 lower is 400
	givePoints(p1, p1x, p1y)
	givePoints(p2, p2x, p2y)
	vx := p2x - p1x
	vy := p2y - p1y
	return {1: vx,2: vy}
}

MakeVectorCoords(x,y){
	return {1: x, 2: y}
}

MakeUnitVector(v){
	z := ModVector(v)
	return {1: (v[1]/z), 2: (v[2]/z)}
}

ModVector(v){
	vx := v[1]
	vy := v[2]
	return sqrt( (vx*vx) + (vy*vy) )
}

radToAngle(rad){
	return rad * 180/PI
}

ObjhasValue(s){
	for k,v in COORDS
		if (v==s)
			return k
	return 0
}

min(a,b){
	return a>b ? b : a
}
max(a,b){
	return a>b ? a : b
}


;++++++++++++++++++++++++++++++++
;      I N I T   D R A W I N G
;++++++++++++++++++++++++++++++++

initDrawing(){
	PLT := ComObjCreate("GflAx.GflAx")
	if FileExist("i.bmp")
		PLT.LoadBitmap("i.bmp")
	else
		PLT.NewBitmap(400, 400)
	PLT.SaveFormatName := "bmp"
	PLT.LineWidth := PLT.LineWidth*2
	return PLT
}