include<config.scad>;
include<modules/spinner_case.scad>;
include<modules/motor_case.scad>;
include<modules/screw.scad>;
include<modules/dispenser.scad>;



WITH_DECORATION = 1;

/*************
 * 3D Models *
 *************/
spinner_case();

if (WITH_DECORATION) {
    %translate([0, spinner_start_y, tube_radius_o]) rotate([-90, 0, 0]) screw();
    %translate([0, spinner_start_y - thickness, tube_radius_o])rotate([90, 0, 0]) motor_case();
    %translate([0, main_case_depth / 2, tube_radius_o]) dispenser();
}