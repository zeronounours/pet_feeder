include<tie.scad>;
include<tube.scad>;
include<motor_case.scad>;

/***********
 * Modules *
 ***********/
module main_case(with_hole=false, with_control_panel=false, with_motor=false) {
    module base_shape() {
        translate([0, 0, main_case_height / 2]) difference() {
            cube([main_case_width, main_case_depth, main_case_height], center=true);
            cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, main_case_height + 1], center=true);
        }
        translate([0, 0, main_case_height + (main_case_tie_length + thickness) / 2 - thickness]) difference() {
            cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, main_case_tie_length + thickness], center=true);
            translate([0, 0, - thickness]) cube([main_case_width - 4 * thickness, main_case_depth - 4 * thickness, main_case_tie_length + thickness], center=true);
        }
    }

    // top of the main case (z direction)
    top = main_case_height + main_case_tie_length;

    difference() {
        base_shape();

        // middle holes
        if (with_hole) cylinder(top + 1, r=main_case_hole_radius);

        // holes for the motor
        if (with_motor) {
            // motor axis hole
            translate([0, main_case_depth / 2 - 1.5 * thickness, main_case_height / 2]) rotate([-90, 0, 0]) cylinder(2 * thickness, r=motor_axis_rad * 1.5);

            // motor case holes
            translate([0, main_case_depth / 2 - thickness, main_case_height / 2]) rotate([90, 0, 0]) motor_case();
        }

        // control panel
        if (with_control_panel) {
            // push button holes
            translate([-control_panel_interval / 2, 0, button_groove / 2 + top - thickness]) cube([button_width, button_width, button_groove], center=true);
            translate([-control_panel_interval / 2, 0, top - thickness]) cylinder(thickness + 2, r=button_radius);

            // led hole
            translate([control_panel_interval / 2, 0, top - led_groove]) cylinder(led_groove, r=led_radius);
            translate([control_panel_interval / 2, 0, top - thickness + thickness / 2]) cube([2 * led_radius, led_feet_width, thickness], center=true);
        }
    }

    if (with_motor) {
        // variables for spinner case tie
        tie_outer_radius = opening_size / 2; // radius of the tie part - forced by spinner_case.scad
        tie_tube_thickness = thickness / 2; // thickness of the tie part
        inner_radius = tie_outer_radius - tie_tube_thickness;

        // spinner case tie
        translate([0, main_case_depth / 2, main_case_height / 2]) rotate([-90, 0, 0]) {
            tube(tie_length, inner_radius, tie_tube_thickness);
            tie(tie_length, tie_outer_radius, tie_thickness);
        }
    }
}
