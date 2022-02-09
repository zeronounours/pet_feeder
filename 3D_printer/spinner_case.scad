include<config.scad>;
include<modules/spinner_case.scad>;
include<modules/motor_case.scad>;
include<modules/screw.scad>;
include<modules/dispenser.scad>;
include<modules/roller.scad>;
include<vendor/arduino_mounting_library_v2/arduino.scad>;

/**************
 * Parameters *
 **************/
WITH_DECORATION = 1;

/*************
 * 3D Models *
 *************/
spinner_case();

if (WITH_DECORATION) {
    %translate([0, spinner_start_y, tube_radius_o]) rotate([-90, 0, 0]) screw();
    %translate([0, spinner_start_y - thickness - roller_edge, tube_radius_o])rotate([90, 0, 0]) motor_case();
    %translate([0, main_case_depth / 2, tube_radius_o]) dispenser();
    %translate([0, spinner_start_y, tube_radius_o]) roller();
    %translate([0, spinner_end_y - roller_length, tube_radius_o]) roller();
    %translate([arduino_support_x, arduino_support_y, arduino_support_height]){
        rotate([0, 0, 180]) arduino();
       }
}