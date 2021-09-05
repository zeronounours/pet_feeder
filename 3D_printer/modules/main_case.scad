include<tie.scad>;
include<tube.scad>;
include<motor_case.scad>;

/***********
 * Modules *
 ***********/
module rounded_cube(d, r, center=false) {
    minkowski() {
        cube([d.x - 2 * r, d.y - 2 * r, d.z / 2], center=center);
        // use a different cylinder, depending on whether it is centered
        if (center) cylinder(d.z / 2, r=r, center=center);
        else translate([r, r, 0]) cylinder(d.z / 2, r=r);
    }
}
module main_case_base_shape(height, with_floor=true) {
    floor_coef = with_floor ? 1: 0;
    translate([0, 0, height / 2]) difference() {
        rounded_cube([main_case_width, main_case_depth, height], r=main_case_corner_radius, center=true);
        rounded_cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, height + 1], r=main_case_corner_radius, center=true);
    }
    translate([0, 0, thickness - (main_case_tie_length + thickness) / 2]) difference() {
        rounded_cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, main_case_tie_length + thickness], r=main_case_corner_radius, center=true);
        translate([0, 0, floor_coef * (-thickness - 1)]) rounded_cube([main_case_width - 4 * thickness, main_case_depth - 4 * thickness, main_case_tie_length + thickness + 1], r=main_case_corner_radius, center=true);
    }
}
module main_case(with_hole=false, with_control_panel=false, with_motor=false) {

    // top of the main case (z direction)
    top = main_case_height + main_case_tie_length;

    difference() {
        base_shape(main_case_height, false);

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
