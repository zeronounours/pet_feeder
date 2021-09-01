include<config.scad>;
include<modules/screw.scad>;
include<modules/case.scad>;
include<modules/dispenser.scad>;

/*************
 * 3D Models *
 *************/
color("blue") screw();
translate([-12, 0, 30]) food();
color("yellow") spring_container();
color("red") translate([0, tie_length + tube_radius, tube_length - opening_size / 2 - thickness]) rotate([90, 0, 0]) dispenser();
