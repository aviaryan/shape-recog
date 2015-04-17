
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
		return drawTriangle()
	else return -1
}

drawTriangle(){
	PLT := initDrawing()

	z := CORNS.maxIndex()
	givePointsInv(CORNS[1], x1, y1)
	givePointsInv(CORNS[2], x2, y2)
	if (z==3)
		givePointsInv(CORNS[3], x3, y3)
	else
		givePointsInv(COORDS[1], x0, y0)

	if (z==3){
		PLT.DrawLine(x2, y2, x1, y1)
		PLT.DrawLine(x3, y3, x2, y2)
		PLT.DrawLine(x3, y3, x1, y1)
	}
	else{
		PLT.DrawLine(x0, y0, x1, y1)
		PLT.DrawLine(x1, y1, x2, y2)
		PLT.DrawLine(x2, y2, x0, y0)
	}
	PLT.SaveBitmap("i")
	ObjRelease(PLT)
	return ID_TRI
}