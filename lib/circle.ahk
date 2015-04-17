
validateCircle(){
	rh := PXR-PXL
	rv := PYT-PYB
	rmin := rh>rv ? rv : rh
	if ( (rh*CIRCACC) < abs(PXT-PXB) )
		return -1
	if ( (rv*CIRCACC) < abs(PYL-PYR) )
		return -1

	if ( distance(COORDS, COORDS[COORDS.MaxIndex()]) > (DIST_APART*rmin) ) ; check for figure closing
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
		return ID_LINE
}