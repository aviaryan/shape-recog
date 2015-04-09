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
* The angle threshold for 3-vertex triangles and qualidaterals is 45 degree. As a perfect triangle is supposed to make 0 and a perfect qualidateral 90, 45 works perfectly fine.

### CHALLENGES

* If drawings is coiled again and again, then duplicate slopes will be detected and hence the program will fail.
* In case of triangle, very large obtuse angles can be a problem. Then maybe we can first identify the triangle and then take care of that obtuse thing.