# Shape Recog

Shape Recog is a figure analyzer and synthesizer. It scans a drawn figure and checks if it's square, rectangle, triangle, circle, line or INVALID. After analyzing a figure, 
it then redraws the perfect representation of that figure.
  

### How it was done

* Main Aim was to detect vertices of the figure
* If vertices are infinite (or 0), then it is a circle. - If vertices are 2 or 3, then it is a triangle. If vertices are 3 or 4, then it is a quadrilateral.
* Now to detect vertices, we take points in order and take slopes with respect to [point+10] and [point-10]th point. If slopes differ by a threshold angle (20), then that's a vertex.
* But here's the problem. The threshold approach will give many points near to each other as vertex because of the above method.
* So we calculate mean of all the points in one family and take that as vertex.
* 3 vertexe'd figures can be either triangle or quadrilateral. But in triangle the backward slope of first vertex and forward slope of last vertex are same. So that separates 
 it from the quadrilateral.
* For quadrilaterals with 3-vertex, the fourth vertex will essentially be the starting point.
* Circles and Lines are both 0-vertex figures but in CIRCLE the ratio of `potential_vertices/total_points` is close to 1 and in line its close to 0.
* Now the next aim is to detect the angles between edges. Angles will help greatly in removing figures that are actually not like the detected geometric figures.
* Creating **Directional Vectors** of coords can help to get the correct angle between 2 edges. Dot (Scalar) Product can help.
* Now when we have angles, we can validate if a figure is a correct triangle/square/rectangle or not.
* Calculating angles for polygons is much better when angle is calculated with help of adjacent vertices. This way we get the best approximated figure.
* Now to validate if figures drawn are closed and symbolically correct, we can use the fact that distance(last_point, first_point) should always be less than 
 distance(last_vertex, first_point). Cases which violate this test should be caught in the *Angle Test*.
* We are also using the [Distance Formula](http://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Line_defined_by_two_points) to check if a figure will actually close or tend to close.
* To validate circles, we calculate the Horizontal Diameter and the Vertical Diameter and compare them. We also check if co-ordinates for these diameters are aligned or not. If the co-ordinates are aligned but diameters are different, the figure is an *oval*.
* For further validating polygons, we check if lines drawn from vertex to vertex are straight or not. We will use the Distance Formula to check for the drawn line's difference with the ideal line.
* We also check if the figure is closing or not. If the last line completes 70% of length of what is should have done, then fine else figure will be shown as INVALID. Again this 
70 is just a random appropriate figure and there's no mathematical proof of why it is used.
* For figuring out whether Square or Rectangle, side lengths are sufficient. As this is done after all those checks for quadrilateral, just testing the length works fine.
* Vertices detected very close to each other are settled to one. This is done as many people tremble around the vertex region.
* There is no need for lines to differ by the threshold angle (20) as it is very large. After a line is detected, we re-check it with threshold angle of 5 to see if it's really a line.
* For incomplete polygons (2-Triangle, 3-Rectangle), user will expect the intersection point to be a vertex. This fact is used in drawing to provide a more-expected correction.
* Drawing Squares and Rectangles was a challenging task as you have to make sure both edge length and angles are according to specifications. In here, we first determine the average length of a side and choose a vertex. Then we continue making sides perpendicular to the previous side and with proper edge length. Concept of Vectors play a huge role in making this possible.


### What we learned from this project

* The correct spelling of *qualidateral*.