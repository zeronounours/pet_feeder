include<config.scad>;
include<modules/motor_case.scad>;
include<modules/motor.scad>;


/*************
 * 3D Models *
 *************/
motor_case();

%rotate([180, 0, 0])  motor();