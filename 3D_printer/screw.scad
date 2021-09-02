include<config.scad>;
include<modules/screw.scad>;

/*************
 * 3D Models *
 *************/
screw();
translate([-12, 0, 30]) food();
