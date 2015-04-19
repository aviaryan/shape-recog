
validateCircle(){
	rh := PXR-PXL
	rv := PYT-PYB
	rmin := rh>rv ? rv : rh
	if ( (rh*CIRCACC) < abs(PXT-PXB) )
		return -1
	if ( (rv*CIRCACC) < abs(PYL-PYR) )
		return -1

	if ( distance(COORDS[1], COORDS[COORDS.MaxIndex()]) > (CIRC_DIST_APART*rmin) ) ; check for figure closing
		return -1
	; for circle rh == rv

	if ( (rmin*CIRCACC) < abs(rh-rv) ) ; if points are aligned then only show OVAL
		return -1 ;ID_OVAL
	return drawCircle()
}

drawCircle(){
	getCircle(x, y, d)
	d /= 2
	plt := initDrawing()
	plt.DrawCircle(x, 400-y, d)
	plt.SaveBitmap("i")
	plt := ""
	return ID_CIR
}

forceCheckCircle(){
	z := COORDS.maxIndex()
	da := {} , xa := {} , ya := {}
	getCircle(x, y, d, xa, ya, da)
	df := d/4
	s := 1
	loop % z
	{
		if (distance(x "-" y, xa[A_Index] "-" ya[A_Index]) > df){
			s := 0
			break
		}
	}
	if (s==0)
		return -1
	else {
		return drawCircle()
	}
}

getCircle(Byref xps, Byref yps, Byref dps, Byref xa="", Byref ya="", Byref da=""){
	z := COORDS.maxIndex()
	xps := 0 , yps := 0, dps := 0
	da := {}
	xa := {}
	ya := {}
	loop % z
	{
		p := COORDS[A_index]
		maxd := 0
		loop % z
		{
			p2 := COORDS[A_Index]
			if (p==p2)
				continue
			d := distance(p2, p)
			if (d>maxd){
				maxd := d
				pt := p2
			}
		}
		givePoints(p, x0, y0)
		givePoints(pt, x1, y1)
		xps += (x0+x1)/2
		yps += (y0+y1)/2
		dps += maxd

		xa.Insert((x0+x1)/2)
		ya.Insert((y0+y1)/2)
		da.Insert( maxd )
	}
	xps /= z
	yps /= z
	dps /= z
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
	if !COORDS.maxIndex()
		return ID_LINE
	plt := initDrawing()
	givePointsInv(COORDS[1], p0x, p0y)
	givePointsInv(COORDS[COORDS.maxIndex()], p1x, p1y)
	plt.DrawLine(p0x, p0y, p1x, p1y)
	plt.SaveBitmap("i")
	ObjRelease(plt)
	return ID_LINE
}