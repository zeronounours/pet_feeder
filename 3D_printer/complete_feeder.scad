include<config.scad>;
include<modules/screw.scad>;
include<modules/spinner_case.scad>;
include<modules/dispenser.scad>;
include<modules/food_container.scad>;
include<modules/main_case.scad>;
include<modules/pin.scad>;
include<modules/motor_case.scad>;
include<modules/motor.scad>;
include<modules/bowl.scad>;
include<modules/lid.scad>;


/**************
 * Parameters *
 **************/
// What pieces to show
SHOW_MAIN_CASE = 1;
SHOW_MAIN_CASE_LOWER = 1;
SHOW_MAIN_CASE_UPPER = 1;
SHOW_MOTOR_CASE = 1;
SHOW_PIN = 1;
SHOW_FOOD_CONTAINER = 1;
SHOW_FOOD_EXTENSION = 1;
SHOW_DISPENSER = 1;
SHOW_SPINNER = 1;
SHOW_SPINNER_CASE = 1;
SHOW_LID = 1;
SHOW_DECORATION = 1;

// whether to split pieces
SPLIT = 0;

/*************
 * 3D Models *
 *************/
SPLIT_DIST = 50 * SPLIT;

translate([0, 0, 0]) {

    if (SHOW_MAIN_CASE && SHOW_MAIN_CASE_LOWER) color("white") main_case();
    if (SHOW_DECORATION) %translate([0, main_case_depth / 2 + BOWL_RADIUS, -main_case_tie_length]) bowl();
translate([0, 0, main_case_height + SPLIT_DIST]) {

    if (SHOW_MAIN_CASE && SHOW_MAIN_CASE_UPPER) color("white") main_case();
translate([0, 0, main_case_height + SPLIT_DIST]) {

    if (SHOW_SPINNER_CASE) color("yellow") spinner_case();
    if (SHOW_DECORATION) %translate([arduino_support_x, arduino_support_y, arduino_support_height]) rotate([0, 0, 180]) arduino();
    if (SHOW_DISPENSER) color("red") translate([0, main_case_depth / 2 + SPLIT_DIST, tube_radius_o]) dispenser();

    // only add height for what's inside the case, if in split mode
translate([0, 0, spinner_case_height * SPLIT + SPLIT_DIST]) {

    if (SHOW_SPINNER) color("white") translate([0, spinner_start_y, tube_radius_o]) rotate([-90, 0, 0]) screw();
    if (SHOW_MOTOR_CASE) color("purple") translate([0, spinner_start_y - thickness - roller_edge, tube_radius_o]) rotate([90, 0, 0]) motor_case();
    if (SHOW_DECORATION) %translate([0, spinner_start_y - thickness - roller_edge, tube_radius_o]) rotate([-90, 0, 0]) motor();

    // If in split mode, add a new split, else add the height of the spinner case
translate([0, 0, 2 * tube_radius * SPLIT + SPLIT_DIST]) {
translate([0, 0, spinner_case_height * (1 - SPLIT) + SPLIT_DIST]) {

    if (SHOW_FOOD_CONTAINER) color("green") food_container();
translate([0, 0, food_case_height + SPLIT_DIST]) {

    if (SHOW_FOOD_EXTENSION) color("darkgreen") food_container_extension(true);
    if (SHOW_PIN) color("black") translate([main_case_width / 2 + SPLIT_DIST, 0, food_container_extension_height / 2]) rotate([0, 0, 90]) rabbit_pin();

translate([0, 0, food_container_extension_height + SPLIT_DIST]) {
    if (SHOW_LID) color("seagreen") lid();

translate([0, 0, main_case_height + SPLIT_DIST]) {

}}}}}}}}}
