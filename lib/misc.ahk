/*
	PROGRAM BASED FS
*/

resolveShapeId(ID){
	if (id == 0)
		return "LINE"
	else if (id == 1)
		return "TRIANGLE"
	else if (id == 2)
		return "SQUARE"
	else if (id == 3)
		return "RECTANGLE"
	else if (id == 4)
		return "CIRCLE"
	else
		return "INVALID"
}

distance(p1, p2){
	p2x := Substr(p2, 1, Instr(p2, "-")-1)
	p2y := Substr(p2, Instr(p2, "-")+1)
	p1x := Substr(p1, 1, Instr(p1, "-")-1)
	p1y := Substr(p1, Instr(p1, "-")+1)
	return Sqrt( (p2y-p1y)**2 + (p2x-p1x)**2 )
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
	return anglefromVertex(vf, vb)
}

anglefromVertex(vf, vb){
	modside := ModVector(vf) * ModVector(vb)
	modfull := vf[1]*vb[1] + vf[2]*vb[2]
	costheta := modfull / modside
	return acos( costheta )
}

validateAngle(a){
	return a>ACC ? a : -100
}

/*
	GENERAL PURPOSE
*/

MakeVector(p1, p2){
	; remember p1 is tail, p2 is head
	; NOTE that coordinate axes are not same here - upper y is 0 lower is 400
	p2x := Substr(p2, 1, Instr(p2, "-")-1)
	p2y := Substr(p2, Instr(p2, "-")+1)
	p1x := Substr(p1, 1, Instr(p1, "-")-1)
	p1y := Substr(p1, Instr(p1, "-")+1)
	vx := p2x - p1x
	vy := p2y - p1y
	return {1: vx,2: vy}
}

ModVector(v){
	vx := v[1]
	vy := v[2]
	return sqrt( vx*vx + vy*vy )
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

