include<config.scad>;
include<modules/screw.scad>;
include<modules/case.scad>;

/*************
 * 3D Models *
 *************/
color("blue") screw();
translate([-12, 0, 30]) food();
color("yellow") spring_container();
