
; 1 is for triangle
validateTriangle(){
	z := CORNS.MaxIndex()
	t := COORDS.MaxIndex()
	angle := 0
	for k,v in CORNS
		angle += validateAngle( angleAtVertex(v) )

	if (z<3)
		angle += validateAngle( anglefromVertex( makeVector(COORDS[1], COORDS[1+M]) , makeVector(COORDS[t], COORDS[t-M]) ) )
			;angleFromPoints(COORDS[1+M], COORDS[1], COORDS[COORDS.MaxIndex()])

	if ( Abs(angle-PI) < TRIACC )
		return 1
	else return -1

	return 1
}