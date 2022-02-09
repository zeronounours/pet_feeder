/**************
 * Parameters *
 **************/
// kept outside of config.scad to keep only parameters related to the pet feeder
// in it, and leave decoration related parameters here
ROLLER_NUM_BALLS = 10;
ROLLER_BALLS_CENTER_RAD = (roller_outner_radius + roller_inner_radius) / 2;
ROLLER_BALLS_RAD = 2 * PI * ROLLER_BALLS_CENTER_RAD / ROLLER_NUM_BALLS / 2;
ROLLER_RING_EDGE = ROLLER_BALLS_CENTER_RAD - 3/4 * ROLLER_BALLS_RAD - roller_inner_radius;

/***********
 * Modules *
 ***********/
module roller() {
    module balls() {
        for(i = [0:ROLLER_NUM_BALLS - 1]) {
            rotate([0, i * 360 / ROLLER_NUM_BALLS, 0]) translate([ROLLER_BALLS_CENTER_RAD, roller_length / 2, 0]) sphere(ROLLER_BALLS_RAD);
        }
    }
    // rings
    rotate([-90, 0, 0]) {
        // inner ringe
        difference() {
            cylinder(roller_length, r=roller_inner_radius + ROLLER_RING_EDGE);
            translate([0, 0, -1]) cylinder(roller_length + 2, r=roller_inner_radius);
        }
        // outer ringe
        difference() {
            cylinder(roller_length, r=roller_outner_radius);
            translate([0, 0, -1]) cylinder(roller_length + 2, r=roller_outner_radius - ROLLER_RING_EDGE);
        }
    }
    balls();
}

