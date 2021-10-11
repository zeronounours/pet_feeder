include<spinner_case.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module dispenser_section(radius, rotate_radius, add_heigth, angle) {
    rotate([-angle, 0, 0])
        translate([0, -rotate_radius, 0])
        long_tube(0.01, (1 - cos(angle)) * add_heigth, radius);
}
module dispenser_base_shape(radius, add_heigth, rotate_radius, from=0, to=90){
    step = 360 / $fn;
    for(a = [from:step:to - step]) {
        hull() {
            dispenser_section(radius, rotate_radius, add_heigth, a);
            dispenser_section(radius, rotate_radius, add_heigth, a + step);
        }
    }
}
module dispenser() {
    outer_radius = tube_radius + 2 * tie_support_thickness + tie_thickness;  // radius for the outer part

    union() {
        // dispenser part
        translate([0, tie_length, -outer_radius - thickness]) rotate([0, 0, 180]) difference() {
            // curved pipe
            dispenser_base_shape(outer_radius, spinner_case_add_height - thickness, outer_radius + thickness);
            dispenser_base_shape(tube_radius, spinner_case_add_height - thickness, outer_radius + thickness, from=-10, to=100);
        }

        // attach part
        rotate([-90, 0, 0]) {
            difference() {
                long_tube(tie_length, spinner_case_add_height - thickness, outer_radius);
                translate([0, tube_radius, 0]) {
                    // remove the inner part
                    translate([0, 0, -1]) long_tube(tie_length + 2, spinner_case_add_height - thickness + tube_radius, tube_radius + tie_support_thickness);
                    // remove a slider part
                    translate([0, 0, tie_length / 2]) long_tube(tie_length / 2, spinner_case_add_height - thickness + tube_radius, tube_radius + tie_support_thickness + tie_thickness);
                }
            }
        }
    }
}

