
; 1 is for triangle
validateTriangle(){
	z := CORNS.MaxIndex()
	t := COORDS.MaxIndex()
	angle := 0
	for k,v in CORNS
		angle += validateAngle( angleAtVertexALAS(k) )

	if (z<3)
		angle += validateAngle( anglefromVector( makeVector(COORDS[1], CORNS[1]) , makeVector(COORDS[t], CORNS[2]) ) )

	if ( Abs(angle-PI) < TRIACC )
		return ID_TRI
	else return -1
}