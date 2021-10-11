include<tube.scad>;
include<main_case.scad>;
include<motor.scad>;
include<../vendor/arduino_mounting_library_v2/arduino.scad>;

/***********
 * Modules *
 ***********/
// module to create a longer tube
module long_tube(height, add_length, radius) {
    hull() {
        cylinder(height, r=radius);
        translate([0, -add_length, 0]) cylinder(height, r=radius);
    }
}

// spring container
module spinner_case() {
    difference() {
        union() {
            // base shape for the main case
            main_case_base_shape(spinner_case_height);

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
            translate([0, input_hole_y - tube_radius - thickness, tube_radius_o]) rotate([-90, 0, 0]) {
                long_tube(tube_length + thickness, spinner_case_add_height + tube_radius, tube_radius_o);
                translate([-tube_radius_o, 0, 0]) cube([2 * tube_radius_o, tube_radius_o, tube_length + thickness]); // to make the lower part square
            }

            // output attach
            translate([0, main_case_depth / 2, tube_radius_o]) rotate([-90, 0, 0]) {
                difference() {
                    long_tube(tie_length, spinner_case_add_height - thickness, tube_radius + tie_support_thickness + tie_thickness);
                    // remove a slider part
                    translate([0, tube_radius, 0]) difference() {
                        long_tube(tie_length / 2, spinner_case_add_height - thickness + tube_radius, tube_radius + tie_support_thickness + tie_thickness + 1);
                        translate([0, 0, -1]) long_tube(tie_length / 2 + 2, spinner_case_add_height - thickness + tube_radius, tube_radius + tie_support_thickness);
                    }
                }
            }

            // standoff for the arduino
            //    center the arduino board
            translate([arduino_support_x, arduino_support_y, 0])
                rotate([0, 0, 180])
                    standoffs(UNO, height=arduino_support_height, mountType=PIN);
        }
        // Extrude the spinner tube
        // cylinder for the spinner
        translate([0, spinner_start_y, tube_radius_o]) rotate([-90, 0, 0]) cylinder(main_case_depth, r=tube_radius);
        // right high part of the tube
        translate([0, input_hole_y - tube_radius, tube_radius_o]) rotate([-90, 0, 0]) {
            long_tube(tube_length - thickness, spinner_case_add_height + tube_radius, tube_radius);
        }
        // hole for the case output opening
        translate([0, input_hole_y - tube_radius, tube_radius_o]) rotate([-90, 0, 0]) {
            long_tube(main_case_depth, spinner_case_add_height - thickness, tube_radius);
        }
        // remove upper part of the translated cylinder
        translate([0, input_hole_y - tube_radius - thickness, tube_radius_o]) rotate([-90, 0, 0])
        translate([-tube_radius_o - 1, -2 * tube_radius_o - 1 - spinner_case_add_height - tube_radius, -1])
            cube([2 * tube_radius_o + 2, 2 * tube_radius_o + 1, tube_length + thickness + 2]);

        // holes for the motor
        translate([0, spinner_start_y - thickness, tube_radius_o]) rotate([-90, 0, 0]) {
            // motor axis hole: make it higher for mounting the motor
            long_tube(motor_axis_len, main_case_height, motor_axis_rad * 1.5);
            // motor case holes
            rotate([180, 0, 0]) motor_case();
        }

        // holes for wires to the lower case
        translate([0, wire_hole_y, -1]) cylinder(spinner_case_height, r=wire_hole_radius);

        // Add gaps to be able to add the above case
        translate([0, 0, spinner_case_height]) main_case_base_shape(1);
    }
}
