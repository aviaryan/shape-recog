
; 1 is for triangle
validateTriangle(){
	z := CORNS.MaxIndex()
	t := COORDS.MaxIndex()
	angle := 0
	for k,v in CORNS
		angle += validateAngle( angleAtVertexALAS(k) )

	if (z<3)
		angle += validateAngle( anglefromVertex( makeVector(COORDS[1], COORDS[1+M]) , makeVector(COORDS[t], COORDS[t-M]) ) )

	if ( Abs(angle-PI) < TRIACC )
		return 1
	else return -1

	return 1
}