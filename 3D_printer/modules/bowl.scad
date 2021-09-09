/**************
 * Parameters *
 **************/
// kept outside of config.scad to keep only parameters related to the pet feeder
// in it, and leave decoration related parameters here
BOWL_HEIGH = 55;
BOWL_RADIUS = 118 / 2;
BOWL_THICKNESS = 6;

/***********
 * Modules *
 ***********/
module bowl() {
    difference() {
        cylinder(BOWL_HEIGH, r=BOWL_RADIUS);
        translate([0, 0, BOWL_THICKNESS]) cylinder(BOWL_HEIGH, r=BOWL_RADIUS - BOWL_THICKNESS);
    }
}
