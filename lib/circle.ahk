
validateCircle(){
	rh := PXR-PXL
	rv := PYT-PYB
	rmin := rh>rv ? rv : rh
	if ( (rh*CIRCACC) < abs(PXT-PXB) )
		return -1
	if ( (rv*CIRCACC) < abs(PYL-PYR) )
		return -1

	if ( distance(COORDS[1], COORDS[COORDS.MaxIndex()]) > (DIST_APART*rmin) ) ; check for figure closing
		return -1
	; for circle rh == rv

	if ( (rmin*CIRCACC) < abs(rh-rv) ) ; if points are aligned then only show OVAL
		return -1 ;ID_OVAL
	return ID_CIR
}


validateLine(){
	acbk := ACC
	ACC := 10*PI/180
	distantCOORDS(10)
	detectCorners()
	ACC := acbk
	if CORNS.maxIndex()
		return -1
	else
		return drawLine() ;ID_LINE
}

drawLine(){
	plt := initDrawing()
	givePointsInv(COORDS[1], p0x, p0y)
	givePointsInv(COORDS[COORDS.maxIndex()], p1x, p1y)
	plt.DrawLine(p0x, p0y, p1x, p1y)
	plt.SaveBitmap("i")
	ObjRelease(plt)
	return ID_LINE
}