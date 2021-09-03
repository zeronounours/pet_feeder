include<config.scad>;
include<modules/screw.scad>;
include<modules/spinner_case.scad>;
include<modules/dispenser.scad>;
include<modules/food_container.scad>;
include<modules/main_case.scad>;
include<modules/pin.scad>;

/*************
 * 3D Models *
 *************/
color("blue") screw();
translate([-12, 0, 30]) food();
color("yellow") spring_container();
color("red") translate([0, tie_length + tube_radius, tube_length - opening_size / 2 - thickness]) rotate([90, 0, 0]) dispenser();
translate([0, -tube_radius - spinner_case_add_height - thickness, 0]) {
    color("green") translate([0, 0, attach_length + opening_size / 2]) rotate([-90, 0, 0]) food_container();
    color("green") translate([0, -tie_length - food_container_slope_height - 1, attach_length + opening_size - food_container_depth / 2 + thickness]) rotate([-90, -90, 0]) food_container_extension(true);
    color("black") translate([food_container_width / 2, -tie_length - food_container_slope_height - 1 - food_container_extension_height / 2, attach_length + opening_size - food_container_depth / 2 + thickness]) rotate([0, -90, 90]) rabbit_pin();
}
color("white") translate([0, spinner_height, -main_case_lower_depth]) rotate([90, 0, 0]) {
    lower_main_case();
    upper_main_case();
}