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
}

distance(p1, p2){
	p2x := Substr(p2, 1, Instr(p2, "-")-1)
	p2y := Substr(p2, Instr(p2, "-")+1)
	p1x := Substr(p1, 1, Instr(p1, "-")-1)
	p1y := Substr(p1, Instr(p1, "-")+1)
	return Sqrt( (p2y-p1y)**2 + (p2x-p1x)**2 )
}

/*
	GENERAL PURPOSE
*/

ObjhasValue(s){
	for k,v in COORDS
		if (v==s)
			return k
	return 0
}

