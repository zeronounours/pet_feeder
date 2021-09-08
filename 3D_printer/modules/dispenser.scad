include<tie.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module dispenser() {
    tie_inner_radius = tube_radius + tie_support_thickness; // radius of the tie part - forced by spinner_case.scad
    outer_radius = tie_inner_radius + thickness;

    rotate([-90, 0, 0]) {
        // tie part
        difference() {
            tube(tie_length, tie_inner_radius, thickness);
            rotate([0, 0, 90]) tie_r(tie_length, tie_inner_radius, tie_thickness);
        }

        // dispenser part
        difference() {
            // curved pipe
            translate([0, 0, tie_length])
                rotate([0, -90, 180])
                translate([0, -outer_radius - thickness, 0])
                rotate_extrude(angle=90)
                translate([outer_radius + thickness, 0, 0])
                difference() {
                    circle(outer_radius);
                    circle(tie_inner_radius);
                }
        }
    }
}

