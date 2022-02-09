include<config.scad>;
include<modules/spinner.scad>;

/*************
 * 3D Models *
 *************/
spinner();
translate([internal_radius / 2, 0, 30]) food();
