include<tube.scad>;

/***********
 * Modules *
 ***********/
module dispenser_section(radius, rotate_radius, add_heigth, angle) {
    rotate([-90 - angle, 0, 0])
        translate([0, -rotate_radius, 0])
        long_tube(0.01, (1 - sin(angle)) * add_heigth, radius);
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
// hole for screws
module hole() {
    translate([dispenser_plate_size / 2 - 5 * screw_radius, dispenser_plate_size / 2 - 5 * screw_radius, -1])
        cylinder(thickness + 2, r=screw_radius);
}
module holes() {
    hole();
    mirror([1, 0, 0]) hole();
    mirror([1, 0, 0]) mirror([0, 1, 0]) hole();
    mirror([0, 1, 0]) hole();
}
// mount plate
module mount_plate() {
    translate([-dispenser_plate_size / 2, -dispenser_plate_size + dispenser_outer_radius, 0]) difference() {
        cube([dispenser_plate_size, dispenser_plate_size, thickness]);
        // remove holes for screws
        translate([dispenser_plate_size / 2, dispenser_plate_size / 2, 0]) holes();
    }
}

module dispenser() {

    union() {
        // dispenser part
        translate([0, tie_length, -dispenser_outer_radius - thickness]) difference() {
            union() {
                // curved pipe
                dispenser_base_shape(dispenser_outer_radius, spinner_case_add_height - thickness, dispenser_outer_radius + thickness);
                // addition for the roller at the end of the axis
                translate([0, 0, dispenser_outer_radius + thickness]) rotate([-90, 0, 0]) cylinder(opening_size + 2 * roller_edge + roller_length + thickness, r=roller_outner_radius + thickness);
            }
            // extrude inner curved pipe
            dispenser_base_shape(tube_radius, spinner_case_add_height - thickness, dispenser_outer_radius + thickness, from=-10, to=100);
            // extrude the axis for the roller
            translate([0, 0, dispenser_outer_radius + thickness]) rotate([-90, 0, 0]) cylinder(opening_size + roller_edge + roller_length, r=roller_outner_radius);
            // extrude the axig to create the roller edge
            translate([0, 0, dispenser_outer_radius + thickness]) rotate([-90, 0, 0]) cylinder(opening_size + 2 * roller_edge + roller_length, r=roller_outner_radius - roller_edge);
        }

        // attach part
        rotate([-90, 0, 0]) {
            difference() {
                union() {
                    long_tube(tie_length, spinner_case_add_height - thickness, dispenser_outer_radius);
                    mount_plate();
                }
                // remove the inner part
                translate([0, 0, -1]) long_tube(tie_length + 2, spinner_case_add_height - thickness, tube_radius + tie_support_thickness + tie_thickness);
            }
        }
    }
}

