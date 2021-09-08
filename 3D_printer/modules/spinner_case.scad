include<tie.scad>;
include<tube.scad>;
include<main_case.scad>;
include<motor.scad>;

/***********
 * Modules *
 ***********/
// module for the openings
module openings(tie_length, inner_r, tube_r, thick, add_height=0) {
    difference() {
        tube(tie_length + tube_r + add_height, inner_r, thick);
        // remove the part inside the container cylinder
        rotate([90, 0, 0]) cylinder(2 * (inner_r + thick), r=tube_r, center=true);
        // tie
        translate([0, 0, tie_length + tube_r + add_height]) rotate([180, 0, 0]) tie_r(tie_length, tube_r, tie_thickness);
    }
}

// spring container
module spinner_case() {
    // height of the case
    case_height = 2 * tube_radius + spinner_case_add_height + thickness;

    difference() {
        union() {
            // base shape for the main case
            main_case_base_shape(case_height);

            // shape for the spinner pipe
            //
            //        +-------------+
            //        |             |
            //   +....+             |
            //   |                  |
            //   +..................+
            //
            // Simple tube for the left part (attach of the spinner)
            translate([0, spinner_start_y - thickness, tube_radius_o]) rotate([-90, 0, 0]) {
                cylinder(attach_length + thickness, r=tube_radius_o);
                translate([-tube_radius_o, 0, 0]) cube([2 * tube_radius_o, tube_radius_o, attach_length + thickness]); // to make the lower part square
            }
            // right high part of the tube
            translate([0, input_hole_y - tube_radius, tube_radius_o]) rotate([-90, 0, 0]) {
                hull() {
                    cylinder(tube_length, r=tube_radius_o);
                    translate([0, -spinner_case_add_height - tube_radius, 0]) cylinder(tube_length, r=tube_radius_o);
                }
                translate([-tube_radius_o, 0, 0]) cube([2 * tube_radius_o, tube_radius_o, tube_length]); // to make the lower part square
            }
        }
        // Extrude the spinner tube
        // whole length of the spinner
        translate([0, spinner_start_y, tube_radius_o]) rotate([-90, 0, 0]) cylinder(main_case_depth, r=tube_radius);
        // right high part of the tube
        translate([0, input_hole_y - tube_radius + thickness, tube_radius_o]) rotate([-90, 0, 0]) {
            hull() {
                cylinder(tube_length - 2 * thickness, r=tube_radius);
                translate([0, -spinner_case_add_height - tube_radius, 0]) cylinder(tube_length - 2 * thickness, r=tube_radius);
            }
        }
        // remove upper part of the translated cylinder
        translate([0, input_hole_y - tube_radius, tube_radius_o]) rotate([-90, 0, 0])
        translate([-tube_radius_o - 1, -2 * tube_radius_o - 1 - spinner_case_add_height - tube_radius, -1])
            cube([2 * tube_radius_o + 2, 2 * tube_radius_o + 1, tube_length + 2]);

        // holes for the motor
        translate([0, spinner_start_y - thickness, tube_radius_o]) rotate([-90, 0, 0]) {
            // motor axis hole: make it higher for mounting the motor
            hull() {
                cylinder(motor_axis_len, r=motor_axis_rad * 1.5);
                translate([0, -main_case_height, 0]) cylinder(motor_axis_len, r=motor_axis_rad * 1.5);
            }
            // motor case holes
            rotate([180, 0, 0]) motor_case();
        }

        // holes for wires to the lower case
        translate([0, wire_hole_y, -1]) cylinder(case_height, r=wire_hole_radius);

        // Add gaps to be able to add the above case
        translate([0, 0, case_height]) main_case_base_shape(1);
    }
    // output attach
    translate([0, main_case_depth / 2, tube_radius_o]) rotate([-90, 0, 0]) {
        tube(tie_length, tube_radius, tie_support_thickness);
        rotate([0, 0, 90])  // rotate to ease printing
            tie(tie_length, tube_radius + tie_support_thickness, tie_thickness);
    }
}
