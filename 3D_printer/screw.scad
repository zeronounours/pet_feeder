include<config.scad>;
include<modules/screw.scad>;

/*************
 * 3D Models *
 *************/
screw();
translate([internal_radius / 2, 0, 30]) food();
