
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
	pIntersectStart(x0, y0) ; better to use this value
	COORDS[1] := x0 "-" y0
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
	f := max(p1,p2)
	if (abs(p1-p2) <= (SQACC*f))
		return drawQuad(1)
	else
		return drawQuad()
}

drawQuad(issq=0){
	z := CORNS.maxIndex()
	; TAKE POINTS (in order)
	/*
	p1---p4
	|     |
	p2---p3
	*/
	p := Object()
	if (z==3){
		pIntersectStart(x0, y0)
		p[1] := x0 "-" y0
		p[2] := CORNS[1]
		p[3] := CORNS[2]
		p[4] := CORNS[3]
	}
	else {
		p[1] := CORNS[1]
		p[2] := CORNS[2]
		p[3] := CORNS[3]
		p[4] := CORNS[4]
	}

	; calc side lengths
	s1 := ( distance(p[1], p[2]) + distance(p[3], p[4]) ) / 2
	s2 := ( distance(p[2], p[3]) + distance(p[4], p[1]) ) / 2
	if (issq)
		s1 := (s1+s2)/2 , s2 := s1

	; get ready for drawing
	plt := initDrawing()
	prev := ""
	p[5] := p[1]

	loop 4
	{
		if !IsObject(prev){
			curv := makeUnitVector( makeVector(p[1], p[2]) )
		} else {
			; ax + by = 0 ; suppose x=1
			x := 1
			y := (-prev[1] * x) / prev[2]
			if (prev[2]==0)
				x := 0, y := 1
			curv := makeUnitVector( makeVectorCoords(x, y) )
		}

		compv := makeVector(p[A_index], p[A_index+1])
		curd := (Mod(A_index,2)==0) ? s2 : s1
		givePoints(p[A_Index], xc, yc)

		pset1 := (xc + curv[1]*curd) "-" (yc + curv[2]*curd)
		pset2 := (xc - curv[1]*curd) "-" (yc - curv[2]*curd)
		pset1v := MakeVector(p[A_Index], pset1)
		pset2v := MakeVector(p[A_index], pset2)

		;msgbox % pset1 " " pset1v[1] " " pset1v[2] "`n" pset2 " " pset2v[1] " " pset2v[2] "`n" anglefromVector(pset1v, compv) " " anglefromVector(pset2v, compv) "`n" compv[1] " " compv[2]
		pf := anglefromVector(pset1v, compv) < anglefromVector(pset2v, compv) ? pset1 : pset2
		givePointsInv(p[A_Index], ix0, iy0)
		givePointsInv(pf, ix1, iy1)
		plt.DrawLine(ix0, iy0, ix1, iy1)

		prev := curv.Clone()
		p[A_index+1] := pf
	}

	plt.SaveBitmap("i")
	ObjRelease(plt)
	return issq ? ID_SQ : ID_RECT
}