include<config.scad>;
include<modules/screw.scad>;
include<modules/spinner_case.scad>;
include<modules/dispenser.scad>;
include<modules/food_container.scad>;
include<modules/main_case.scad>;
include<modules/pin.scad>;
include<modules/motor_case.scad>;
include<modules/motor.scad>;


/**************
 * Parameters *
 **************/
// Whether to rotate in a more understandable position
ROTATE_WHOLE = 1;

// What pieces to show
SHOW_MAIN_CASE = 1;
SHOW_MAIN_CASE_LOWER = 1;
SHOW_MAIN_CASE_MIDDLE = 1;
SHOW_MAIN_CASE_UPPER = 1;
SHOW_MOTOR_CASE = 1;
SHOW_PIN = 1;
SHOW_FOOD_CONTAINER = 1;
SHOW_FOOD_EXTENSION = 1;
SHOW_DISPENSER = 1;
SHOW_SPINNER = 1;
SHOW_SPINNER_CASE = 1;
SHOW_DECORATION = 1;

/*************
 * 3D Models *
 *************/
rotate([ROTATE_WHOLE * 90, 0, 0]) {
    if (SHOW_SPINNER) color("blue") screw();
    if (SHOW_SPINNER_CASE) color("yellow") spring_container();
    if (SHOW_DISPENSER) color("red") translate([0, tube_radius, tube_length - opening_size / 2 - thickness]) rotate([90, 0, 0]) dispenser();
    translate([0, -tube_radius - spinner_case_add_height - thickness, 0]) {
        if (SHOW_FOOD_CONTAINER) color("green") translate([0, 0, attach_length + opening_size / 2]) rotate([-90, 0, 0]) food_container();
        if (SHOW_FOOD_EXTENSION) color("green") translate([0, -tie_length - food_container_slope_height - 1, attach_length + opening_size - food_container_depth / 2 + thickness]) rotate([-90, -90, 0]) food_container_extension(true);
        if (SHOW_PIN) color("black") translate([food_container_width / 2, -tie_length - food_container_slope_height - 1 - food_container_extension_height / 2, attach_length + opening_size - food_container_depth / 2 + thickness]) rotate([0, -90, 90]) rabbit_pin();
    }
    if (SHOW_MAIN_CASE) color("white") translate([0, 0, -main_case_depth / 2]) rotate([90, 0, 0]) {
        if (SHOW_MAIN_CASE_UPPER) translate([0, 0, -main_case_height / 2]) main_case(with_motor=true, with_control_panel=true);
        if (SHOW_MAIN_CASE_MIDDLE) translate([0, 0, -main_case_height / 2 - main_case_height]) main_case(with_hole=true);
        if (SHOW_MAIN_CASE_LOWER) translate([0, 0, -main_case_height / 2 - 2 * main_case_height]) main_case();
    }
    if (SHOW_MOTOR_CASE) color("purple") translate([0, 0, -thickness]) rotate([180, 0, 0]) motor_case();

    // Decoration
    if (SHOW_DECORATION) {
        translate([-12, 0, 30]) food();
        translate([-12, 0, attach_length + spring_length]) food();
        %translate([0, 0, -thickness]) motor();
    }
}
