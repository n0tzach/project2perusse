

function heartx(t) = 16*(sin(t))^3;

function hearty(t) = 13*cos(t)-5*cos(2*t)-2*cos(3*t)-cos(4*t);


// a and b are constants that the function can use to manipulate its shape
// xmin and xmax denote the domain of the 2D graph, with delta being the splotting step from xmin to xmax
//zheight is the vertical height of the plot
// ywidth is the y-axis thickness of the shape before it is rotated. a unit circle or unit square would have ywidth=1
// polynum designates the xy-plane shape to draw using the circle() function's $fn command. $fn=50 for a high resolution circle, $fn=4 for a square.



module mirrory(keepchild=false) {


    mirror([1,0,0]) children();
    
    if (keepchild) children();

}

module plotHeart(mult=1,thickness=1) {

    union()

    mirrory(keepchild=true)
    for(t=[2:1:180]) 
        hull() {
            
            translate([mult*heartx(t),mult*hearty(t),0]) circle(r=thickness/2);
        
            translate([mult*heartx(t-1),mult*hearty(t-1),0]) circle(r=thickness/2);
            
            translate([mult*heartx(t-2),mult*hearty(t-2),0]) circle(r=thickness/2);
        } // end hull()
        
}// end plotHeart()

module plotHeart2(mult=1,thickness=1) {

    union()

    mirrory(keepchild=true)
    for(t=[2:1:180]) 
        hull() {
            
            translate([mult*heartx(t),mult*hearty(t),0]) circle(r=thickness/2);
        
            translate([mult*heartx(t-1),mult*hearty(t-1),0]) circle(r=thickness/2);
            
            translate([mult*heartx(t-2),mult*hearty(t-2),0]) circle(r=thickness/2);
        } // end hull()
        
}// end plotHeart()







//
// 1) Define base heart parametric equations
//
function heartX(t) = 32 * sin(t)^3;
function heartY(t) = 26 * cos(t)
                    - 10 * cos(2*t)
                    -  4 * cos(3*t)
                    -  2 * cos(4*t);

//
// 2) Define the derivatives for the tangent vector
//
function dHeartX(t) = 96 * sin(t)^2 * cos(t); // derivative of 32(sin(t))^3
function dHeartY(t) =
    -26*sin(t)
    +20*sin(2*t)
    +12*sin(3*t)
    + 8*sin(4*t);

//
// 3) Helper: Compute the unit tangent and normal
//
function unitTangent(t) =
    let (
        tx = dHeartX(t),
        ty = dHeartY(t),
        len = sqrt(tx*tx + ty*ty)
    )
    (len == 0)
    ? [0, 0]             // fallback if derivative is 0
    : [tx/len, ty/len];

function unitNormal(t) =
    let (
        ut = unitTangent(t)
    )
    // Rotate the tangent by +90° (counterclockwise) to get the normal:
    [ -ut[1], ut[0] ];

//
// 4) "Wavy Normal" version:
//    Offsets the heart in the normal direction by A*sin(w*t + phi).
//
function wavyNormal(t, A, w, phi) =
    let(
        N = unitNormal(t),
        offset = A * sin(w * t + phi)
    )
    [
        heartX(t) + offset*N[0],
        heartY(t) + offset*N[1]
    ];

//
// 5) "Wavy Tangent" version:
//    Offsets the heart in the tangent direction by A*sin(w*t + phi).
//
function wavyTangent(t, A, w, phi) =
    let(
        T = unitTangent(t),
        offset = A * sin(w * t + phi)
    )
    [
        heartX(t) + offset*T[0],
        heartY(t) + offset*T[1]
    ];

// -----------------------------------------------------------------
// Example usage:  Plot circles (diameter=2.4) at wavyNormal points.
// -----------------------------------------------------------------
module wavy_normal_heart(amplitude=2, frequency=6, phase=0) {
    for (deg = [3 : 1 : 177]) {
        // Convert deg to radians for the parametric function:
        t = deg;
        pt = wavyNormal(t, amplitude, frequency, phase);
        ptt = wavyNormal(t-1, amplitude, frequency, phase);
        pttt = wavyNormal(t-2, amplitude, frequency, phase);


hull() {
        translate(pt) circle(d=0.4);
        translate(ptt) circle(d=0.4);
        translate(pttt) circle(d=0.4);
}
    }
}

// -----------------------------------------------------------------
// Similarly, if you want the tangent-wave version:
// -----------------------------------------------------------------
module wavy_tangent_heart(amplitude=2, frequency=12, phase=0) {
    for (deg = [3 : 1 : 180]) {
        t = deg * 3.14159 / 180;
        tt=(deg-1) * 3.14159 / 180;
        ttt=(deg-2) * 3.14159 / 180;
        
        pt = wavyTangent(deg, amplitude, frequency, phase);
        ptt = wavyTangent(deg-1, amplitude, frequency, phase);
        pttt = wavyTangent(deg-2, amplitude, frequency, phase);
 //       translate(pttt) circle(d=0.4);
    //    echo(pt, ptt, pttt);
        hull() {
        translate(pt) circle(d=0.4);
        translate(ptt) circle(d=0.4);
        translate(pttt) circle(d=0.4);
        }

    }
}


module placeVerticalTangent(xval = 50) {

    color("red",0.4) linear_extrude(height=30)
    translate([xval,0,0])
    union() {
    square([2
    ,75],center=true);

    
    hull() {
    translate([1,75/2])
    rotate([0,0,-60])
    square([75/16,2/3],center=true);
 

    translate([-1,75/2])
    rotate([0,0,60])
    square([75/16,2/3],center=true);
 
    }
    
    hull() {
    translate([1,-75/2])
    rotate([0,0,60])
    square([75/16,2/3],center=true);
 

    translate([-1,-75/2])
    rotate([0,0,-60])
    square([75/16,2/3],center=true);
 
    }

 
    }

//    translate([1.5*radius/2,-1*thickness/1.75])
   // rotate([0,0,30])
   // square([1.5*radius/8,thickness/3],center=true);
  //  }

/*    
    hull() {
    translate([-1*1.5*radius/2,thickness/1.75])
    rotate([0,0,30])
    square([1.5*radius/8,thickness/3],center=true);

    translate([-1*1.5*radius/2,-1*thickness/1.75])
    rotate([0,0,-30])
    square([1.5*radius/8,thickness/3],center=true);
    }
*/
    
}

// Example: Uncomment to render one of them
// wavy_normal_heart(2, 6, 0);
 //wavy_tangent_heart(12, 16, 0);

//linear_extrude(height=4)
// wavy_normal_heart(0.8, 16, 0);
 

// All of the code below from line 241 to line 258 is used to plot the heart shape

linear_extrude(height=30)
union() {
    difference() {
        plotHeart2(mult=2,thickness=2.4);

        offset(r=-0.8)
        plotHeart2(mult=2,thickness=2.4);
    }
    mirrory(keepchild=true)
    wavy_normal_heart(0.8, 16, 0);
}

translate([0,0,30-0.6])
linear_extrude(height=0.9)
plotHeart2(mult=2,thickness=2.4);

linear_extrude(height=0.6)
plotHeart2(mult=2,thickness=2.4);

 

 // Use the placeVerticalTangent function to place the vertical tangent lines where you found x'(t) = 0.
 
 // change the xval to your values
placeVerticalTangent(xval=-32);
placeVerticalTangent(xval=32);