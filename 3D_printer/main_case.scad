include<config.scad>;
include<modules/main_case.scad>;

WITH_HOLE = true;
WITH_MOTOR_TIE = false;
WITH_CONTROL_PANEL = false;

/*************
 * 3D Models *
 *************/
main_case(WITH_HOLE, WITH_CONTROL_PANEL, WITH_MOTOR_TIE);
