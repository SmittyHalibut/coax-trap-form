/*
 * The official home for these files is https://github.com/SmittyHalibut/coax-trap-form
 *
 * A form for a coax trap, to make a trap dipole
 * Electrical design from the 2015 ARRL Antenna Handbook 
 * page 10-15, section 10.2.2, "Five Band W3DZZ Trap Antenna"
 * The idea is a trap resonant at 7.2MHz, which natively builds a 40/80m
 * antenna. But the series capacitance in the trap allows the total antenna
 * length to resonate at 20, 15, and 10m as well, at higher harmonics.
 * The idea being a 5 band antenna with only a single pair of traps.
 * 
 * The book shows two designs, depending on which diagram you look at:
 * 1: Traps: 60pF, 8.2uH, 22' outer wire length
 * 2: Traps: 100pF, 4.9uH, 21' outer wire length
 * Both have 32' inner length, and are fed with 75ohm.
 * 
 * My goal is to make these traps using the coax trap design discussed
 * later in the chapter.
 * 
 * Using: https://www.qsl.net/ve6yp/coaxtrap.zip coax trap calculator, 
 * and C/ft numbers for coax I had on hand (RG8/X and RG58), I wasn't
 * able to make a coax trap with the values above; all common coax has
 * too much C/ft to get down to 100pF.  The best I could do was with my 
 * RG8/X, down to 137pF and 3.575uH, 6.25 turn on a 3.1in form.
 * 
 * This is that form, with holes in the right places for coax and attachments.
 * Printed vertically like a tower, THIS WILL NOT BE STRUCTURAL! 
 * My intention is to feed the antenna wire through a nylon rope so the 
 * rope is tensioned, but the wire is not.  The trap structure will just be loosely
 * hanging from the wire ends that stick out from the rope an inch or two.
 */
 
// What are the parameters of the form for your particular trap?
// Calculator: https://www.qsl.net/ve6yp/coaxtrap.zip
form_diameter_in = 3.1;
num_turns = 6.25;

// What Coax are you using?
// RG8/X, LMR240 = 0.242
// RG58, LMR195 = 0.195
coax_diameter_in = 0.242;

// What size bolt are you using to attach to the antenna? 
// Oversize by ~10%; 3D printing isn't that precise, and OpenSCAD models circles with lines
// on the INSIDE of the circle, so the actual dimention is smaller than you think.
// No 10-24 = 0.200
bolt_diameter_in = 0.200;

// How thick do you need the form to be?  Thicker is stronger, but is heavier and takes
// more material.  I find .150" to be pretty good, but adjust as you need.
form_thickness_in = .150;
 
// Derived dimensions; you shouldn't need to change these:
in2mm = 25.4;
form_diameter = form_diameter_in * in2mm;
coax_diameter = coax_diameter_in * in2mm;
bolt_diameter = bolt_diameter_in * in2mm;
form_thickness = form_thickness_in * in2mm;

coax_radius = coax_diameter/2;
coax_turns_height = coax_diameter * num_turns;
coax_turns_angle = num_turns * 360;
trap_length = coax_turns_height + coax_diameter*2;  // One diameter on either side for "slack"
extra_length = bolt_diameter*3;  // Additional form length on either side of the coil
bolt_surface_radius = bolt_diameter; 
bolt_surface_height = form_thickness*2;
total_body_length = trap_length + extra_length*2;

// Form is 1mm radius bigger than specified, so when we scoop out 1mm of turn for the
// coax, we're back to the desired diameter
form_radius = form_diameter/2;
form_radius_actual = form_radius + 1;

 
// Main form Body
difference() {
    cylinder(h=trap_length, r=form_radius_actual, center=false, $fn=100);
    // Take out the center core
    translate([0, 0, -1]) cylinder(h=trap_length+2, r=form_radius_actual-form_thickness, center=false, $fn=100);
    // Entry hole, at 0 degrees
    translate([form_radius, 0, coax_diameter]) {
        rotate(a=90, v=[0, 1, 0]) cylinder(h=form_thickness*2, d=coax_diameter*1.1, center=true, $fn=20);
        // Rounding the corners for coax bending into the inside.
        translate([-coax_radius*1.1, coax_radius*2, 0]) rotate(a=-90, v=[0, 0, 1])
            helix_extrude(angle=90, height=0, $fn=20) translate([coax_radius*2.0, 0, 0]) circle(r=coax_radius, $fn=20);
    }

    // Entry hole, at num_turns degrees
    rotate(a=num_turns*360, v=[0, 0, 1]) translate([form_radius, 0, coax_turns_height + coax_diameter]) {
        rotate(a=90, v=[0, 1, 0]) cylinder(h=form_thickness*2, d=coax_diameter*1.1, center=true, $fn=20);
        // Rounding the corners for coax bending into the inside.
        translate([-coax_radius*1.1, -coax_radius*2, 0]) 
            helix_extrude(angle=90, height=0, $fn=20) translate([coax_radius*2.0, 0, 0]) circle(r=coax_radius, $fn=20);
    }
    
    // Coax troff
    // Using built-in linear extrude; doesn't work. :-(
    //translate([0, 0, coax_diameter])
    //   #linear_extrude(height = coax_turns_height, center=false, convexity=10, twist = 360*num_turns, $fn=100) 
    //       translate([form_radius + coax_diameter/2, 0, 0])
    //           circle(r=coax_diameter/2);
    
    // Using occamsshavingkit code from github. Works, but doesn't render?
    //$fn=50;
    //coax = he_rotate([90, 0, 0], he_translate([form_radius+coax_radius, 0, 0], he_circle(coax_diameter)));
    //translate([0, 0, coax_diameter])
    //    helix_extrude(shape=coax, pitch=coax_diameter, rotations=num_turns);
    
    // Using thingiverse code
    translate([0, 0, coax_diameter])
        helix_extrude(angle=coax_turns_angle, height=coax_turns_height, $fn=100)
           translate([form_radius + coax_radius, 0, 0])
               circle(r=coax_radius, $fn=20);
               
    
    
}
// Extra bit on top
translate([0, 0, trap_length]) {
    difference() {
        union() {
            difference() {
                cylinder(h=extra_length, r=form_radius_actual, center=false, $fn=100);
                // Take out the center core
                translate([0, 0, -1]) cylinder(h=extra_length+2, r=form_radius_actual-form_thickness, center=false, $fn=100);
            }
            rotate(a=num_turns*360, v=[0, 0, 1]) {
                // Bolt surface, outside
                translate([form_radius_actual, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
                    cylinder(h=form_thickness/2, d2=bolt_diameter*2, d1=bolt_diameter*3, center=true, $fn=20);
                // Bold surface, inside
                translate([form_radius_actual-form_thickness, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
                    cylinder(h=form_thickness/2, d1=bolt_diameter*2, d2=bolt_diameter*3, center=true, $fn=20);
            }
        }
        // Mount hole for hardware
        rotate(a=num_turns*360, v=[0, 0, 1])
            translate([form_radius-form_thickness/2, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
                cylinder(h=bolt_surface_height*2, d=bolt_diameter, center=true, $fn=20);
    }
        
}

// ...and on bottom
translate([0, 0, -extra_length]) {
    difference() {
        union() {
            difference () {
                cylinder(h=extra_length, r=form_radius_actual, center=false, $fn=100);
                // Take out the center core
                translate([0, 0, -1]) cylinder(h=extra_length+2, r=form_radius_actual-form_thickness, center=false, $fn=100);
            }
            // Bolt surface, outside
            translate([form_radius_actual, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
                cylinder(h=form_thickness/2, d2=bolt_diameter*2, d1=bolt_diameter*3, center=true, $fn=20);
            // Bold surface, inside
            translate([form_radius_actual-form_thickness, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
                cylinder(h=form_thickness/2, d1=bolt_diameter*2, d2=bolt_diameter*3, center=true, $fn=20);
            
        }
        // Mount hole for hardware
        translate([form_radius-form_thickness/2, 0, bolt_diameter*1.5]) rotate(a=90, v=[0, 1, 0])
            cylinder(h=bolt_surface_height*2, d=bolt_diameter, center=true, $fn=20);
    }
        
}


// The following code is from https://www.thingiverse.com/thing:2200395
// Yes, code on thingiverse. I had never see it either.
 module helix_extrude(angle=360, height=100) {
        precision = $fn ? $fn : 24;

        // Thickness of polygon used to create an helix segment
        epsilon = 0.001;

        // Number of segments to create.
        //   I reversed ingenering rotate_extrude
        //   to provide a very similar behaviour.
        nbSegments = floor(abs(angle * precision / 360));

        module helix_segment() {
                // The segment is "render" (cached) to save (a lot of) CPU cycles.
                render() {
                        // NOTE: hull() doesn't work on 2D polygon in a 3D space.
                        //   The polygon needs to be extrude into a 3D shape
                        //   before performing the hull() operation.
                        //   To work around that problem, we create extremely
                        //   thin shape (using linear_extrude) which represent
                        //   our 2D polygon.
                        hull() {
                                rotate([90, 0, 0])
                                        linear_extrude(height=epsilon) children();

                                translate([0, 0, height / nbSegments])
                                        rotate([90, 0, angle / nbSegments])
                                                linear_extrude(height=epsilon) children();
                        }
                }
        }

        union() {
                for (a = [0:nbSegments-1])
                        translate([0, 0, height / nbSegments * a])
                                rotate([0, 0, angle / nbSegments * a])
                                        helix_segment() children();
        }
}
