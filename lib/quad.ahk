
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
	return ID_SQ
}