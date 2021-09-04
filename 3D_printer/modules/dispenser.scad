include<tie.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module dispenser() {
    tie_outer_radius = opening_size / 2; // radius of the tie part - forced by spinner_case.scad
    tie_tube_thickness = thickness / 2; // thickness of the tie part
    outer_radius = tie_outer_radius + thickness; // global radius - forced by spinner_case.scad
    inner_radius = tie_outer_radius - tie_tube_thickness;
    // tie to the spring container
    tube(tie_length, inner_radius, tie_tube_thickness);
    tie(tie_length, tie_outer_radius, tie_thickness);

    // dispenser part
    difference() {
        // First the external part
        union() {
            translate([0, outer_radius + thickness, 0]) rotate([-90, 0, -90]) {
                // curved pipe part
                rotate_extrude(angle=45) translate([outer_radius + thickness, 0, 0]) circle(outer_radius);
                // continue the pipe
                rotate([-90, 0, 45]) translate([outer_radius + thickness, 0, 0]) cylinder(outer_radius * 3, r=outer_radius);
            }
            // Add a support for the whole stability
            //translate([0, 0, -2 * main_case_height]) cylinder(2 * main_case_height, r=outer_radius / 2);
        }

        // Remove the internal part
        union() {
            translate([0, outer_radius + thickness, 0]) rotate([-90, 0, -90]) {
                // curved pipe part
                rotate_extrude(angle=45) translate([outer_radius + thickness, 0, 0]) circle(inner_radius);
                // pipe continuation
                rotate([-90, 0, 45]) translate([outer_radius + thickness, 0, 0]) translate([0, 0, -1]) cylinder(outer_radius * 3 + 2, r=inner_radius);
            }
        }

        // Remove the end of the pipe to make the output vertical
        translate([-outer_radius - 1, outer_radius + thickness, -4 * outer_radius]) cube([2 * outer_radius + 2, 3 * outer_radius, 4 * outer_radius]);
    }
}

