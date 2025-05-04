Nnumber = 01593667; // Put your N number here without the 'N'


radius = 30;
thickness = 2;

pointThickness = 2;

facets = 100;


/*[Axes]*/
xmin = -45;
xmax = 50;
ymin = -45;
ymax = 52;




$fn = facets;

angleForPts = getAngles();
echo("angles: ", angleForPts);
echo(radius, angleForPts[0],angleForPts[1],angleForPts[2],angleForPts[3]);
echo("points");
pts = getPts(r = radius, angleForPts);
echo(pts);



// Have you noticed that openSCAD circlss aren't really circles, they're discs? A circle is just the outer edge of what openSCAD calls a circle.
//
// justCircle() gives a closer approximation to a circle by creating a thin annulus with a given thickness. 
//
// By default it is centered at the given radius, which means half the thickness will be inside the circle and half will be outside the circle.
// 
// For extra credit and fame you can write the two other versions of the *align* variable - 
// align = "inner" in which the entire thickness is inside the circle, just touching the edge of the circle at the given radius
// align = "outer" in which the entire thickness is outside the circle, just touching the edge of the circle at the given radius
// if you have any questions, ask!

module justCircle(radius = 10, thickness = 1, align = "center") {

    // look up "assert", it's helpful for writting code that doesn't have unexpected behavior

    assert( (radius > 0) && (thickness > 0) , "What does a zero or negative radius or thickness even mean?!");

    if (align == "center") {
        
        assert(thickness <= 2*radius, "For a center aligned circle the thickness can be no greater than twice the radius");


        // We take one circle expanded out by half the thickness. Then we remove from it (the difference) another circle that has been contracted by half the thickness, leaving an annulus with the expected thickness
        
        difference() {
        
            circle(r = radius + thickness / 2);
        
            circle(r = radius - thickness / 2);
        
        }
        
    }
    else if (align == "inner") {
    
        echo("Write the correct code to get your name up in lights for future semesters! (and some extra credit too)");
    
    }
    else if (align == "outer") {
    
        echo("Write the correct code to get your name up in lights for future semesters! (and some extra credit too)");
    
    }
    else {
    
        echo("If you can see this then the good news is that your vision is still working.  But the bad news is that you likely had a typo. It happens, don't beat yourself up about it. I laugh at myself when I do it.");
        
    } // end all the align shennanigans


} // end justCircle()

module makeAxes(xmin = -10, xmax = 10, ymin = -10, ymax = 10) {

xsize = xmax - xmin;
ysize = ymax - ymin;

    // x-axis is 1 unit thick in the y direction, so half the axis has positive y values and half has negative

    translate([(xmin+xmax)/2,0,0])
    square([xsize, 1], center = true);

    // y-axis
    translate([0,(ymin+ymax)/2,0])    
    square([1, ysize], center = true);

}

function getAngles(Nnumber = 00013473) = [rands(1, 81, 1, Nnumber),rands(91, 179, 1, Nnumber),rands(181, 269, 1, Nnumber),rands(271, 359, 1, Nnumber)];

function getPts(r = radius, angles = [45,135,225,315]) = 
    
    [[r*cos(angles[0][0]),r*sin(angles[0][0])],
    [r*cos(angles[1][0]),r*sin(angles[1][0])],
    [r*cos(angles[2][0]),r*sin(angles[2][0])], 
    [r*cos(angles[3][0]),r*sin(angles[3][0])]];
    
    


module makeCircleWithPoints() {

linear_extrude(height=3)

union() {

    %translate([50,50]) text("x + y  = 900");
    %translate([57,57]) text("2        2", size = 6);

    makeAxes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax);

    translate([xmax,0,0])
    circle(r=pointThickness+2,$fn = 3);

    translate([xmax-5,0.25,0])
    text("x", size = 6, font="Pacifico:style=Regular",halign="center");
    //color("red", 0.6) 
    justCircle(radius = radius, thickness = thickness);

    translate([0,ymax,0])
    rotate([0,0,90])
    circle(r=pointThickness+2,$fn = 3);

    translate([0.25,ymax-6,0])
    text("y", size = 6, font="Pacifico:style=Regular", halign = "right");

    
    
       for( i = pts ) {

         
        translate(i)
        circle(r=pointThickness);

        
        }// end for


        translate([0,ymax+4.5])   difference() {
            offset(r=2)
            circle(r=pointThickness);
            
            offset(r=0.5)
            circle(r=pointThickness);
            
        }
    
    
    } // end union

    
} // end makeCircleWithPoints

// This module makes a line of a required thickness and length and arrows on the end
module makeLine() {

    linear_extrude(height=3)
    union() {
    square([thickness,1.5*radius],     center = true);

    hull() {
        translate([thickness/1.75,1.5*radius/2])
        rotate([0,0,-30])
        square([1.5*radius/8,thickness/3],center=true);

        translate([-1*thickness/1.75,1.5*radius/2])
        rotate([0,0,30])
        square([1.5*radius/8,thickness/3],center=true);
    } // end first hull for arrows

    
    hull() {
        translate([thickness/1.75,-1*1.5*radius/2])
        rotate([0,0,30])
        square([1.5*radius/8,thickness/3],center=true);

        translate([-1*thickness/1.75,-1*1.5*radius/2])
        rotate([0,0,-30])
        square([1.5*radius/8,thickness/3],center=true);
    } // end 2nd hull for arrows

   } // end union
    
} // end makeLine()


//Example of a line placed at the 330 degree angle (so the ordered pairs are (radius * cos(330 degrees), radius & sin(330 degrees));
module simpleExample() {

    union() {
    makeCircleWithPoints();

    // example line at 330 degrees
    xpoint = radius*sqrt(3)/2;
    ypoint = -1*radius*1/2;

    //echo(xpoint,ypoint);

    // example rotation for 330 degrees
    rotationAngle=0;

    //translate([xpoint,ypoint,0])
    // Change this angle to match the lines you need to plot
    translate([0,0])
    translate([0,0,0])
    rotate([0,0, 0]) 
    makeLine();


    %translate([30,-30])
    text("tangent line at 330 degrees");
   
    }
    
    
}

simpleExample();
 

//loop to draw tangent lines at each point
for (i = [0:3]) {
    pt = pts[i];
    angle = angleForPts[i][0]; //original angle in degrees

    tangentAngle = angle;

    translate(pt)
    rotate([0, 0, tangentAngle])
    makeLine();
}

// The lines below should give errors if you try to run them. Can you guess why?
//justCircle(radius = 10, thickness = 20.1);
//justCircle(radius = -10, thickness = 1);
//justCircle(radius = 10, thickness = -1);



