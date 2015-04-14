
; 2 is for square, 3 is for rectangle
validateQuad(){
	z := CORNS.MaxIndex()
	t := COORDS.MaxIndex()

	suc := 1, angle := 0
	for k,v in CORNS
	{
		a := angleAtVertexALAS(k)
		if (abs(a-PI2) > RANGLEACC)
			suc := 0
		angle += a
	}

	if (z==3){
		a := anglefromVector( makeVector(COORDS[1], CORNS[1]) , MakeVector(COORDS[t], CORNS[3]) )
		if (abs(a-PI2) > RANGLEACC)
			suc := 0
		angle += a
	}

	if (abs(angle-PI*2) > QUADACC) ; not even a qualidateral 
		return -1
	else if (suc == 0)
		return ID_QUAD
	else
		return SquareOrRect()
}


SquareOrRect(){
	; in 3 vertex sq , the starting point will be the fourth point
	z := CORNS.MaxIndex()
	if (z==4)
		s1 := distance(CORNS[4], CORNS[1])
	else
		s1 := distance(COORDS[1], CORNS[1])
	s2 := distance(CORNS[1], CORNS[2])
	s3 := distance(CORNS[2], CORNS[3])
	if (z!=4)
		s4 := distance(CORNS[3], COORDS[1])
	else
		s4 := distance(CORNS[3], CORNS[4])

	p1 := min(s1, s3)
	if (abs(s1-s3) > (QUADSIDEACC*p1))
		return ID_QUAD
	p2 := min(s2, s4)
	if (abs(s2-s4) > (QUADSIDEACC*p2))
		return ID_QUAD
	f := min(p1,p2)
	if (abs(p1-p2) <= (QUADSIDEACC*f))
		return ID_SQ
	else
		return ID_RECT
}