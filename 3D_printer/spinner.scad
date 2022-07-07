include<config.scad>;
include<modules/spinner.scad>;
include<modules/motor_attach.scad>;

/*************
 * 3D Models *
 *************/
spinner();
translate([internal_radius / 2, 0, 30]) food();
motor_attach();
