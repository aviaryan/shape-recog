validateCircle(){
	boundaries()
	rh := PXR-PXL
	rv := PYT-PYB
	rmin := rh>rv ? rv : rh
	if ( (rh*CIRCACC) < abs(PXT-PXB) )
		return -1
	if ( (rv*CIRCACC) < abs(PYL-PYR) )
		return -1
	if ( (rmin*CIRCACC) < abs(rh-rv) ) ; if points are aligned then only show OVAL
		return ID_OVAL
	return ID_CIR
}