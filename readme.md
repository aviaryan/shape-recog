# Shape Recog

### HOW IT WAS DONE

* Main Aim was to detect vertices of the figure
* If vertices are infinite (or 0), then it is a circle. - If vertices are 2 or 3, then it is a triangle. If vertices are 3 or 4, then it is a qualidateral.
* Now to detect vertices, we take points in order and take slopes with respect to [point+10] and [point-10]th point. If slopes differ by a threshold angle, then that's a vertex.
* But here's the problem. The threshold approach will give many points near to each other as vertex because of the above method.
* So we calculate mean of all the points in one family and take that as vertex.
* 3 vertexed figures can be either triangle or qualidateral. But in triangle the backward slope of first vertex and forward slope of last vertex are same. So that separates 
 it from the qualidateral.
* The point+10th and point-10th approach has a problem when the vertex is drawm at the end of the drawing sequence. Then the last points are overlooked and so vertex is never found. But extra looping for the last points seems to solve this problem.
* For qualidaterals with 3-vertex, the fourth vertex will essentially be the starting point.
* Circles and Lines are both 0-vertex figures but in CIRCLE the ratio of `potential_vertices/total_vertices` is close to 1 and in line its close to 0.
* Now the next aim is to detect the angles between edges. Angles will help greatly in removing figures that are actually not like the detected geometric figures.
* Creating **Directional Vectors** of coords can help to get the correct angle between 2 edges. Dot (Scalar) Product can help.
* Now when we have angles, we can validate if a figure is a correct triangle/square/rectangle or not.
* For 1-vertex figures which can accidentally be a circle, we check for the ratio discussed earlier. If ratio is OK, that's a circle else INVALID.
* Calculating angles for polygons is much better when angle is calculated with help of adjacent vertices. This way we get the best approximated figure.