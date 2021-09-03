include<config.scad>;
include<modules/main_case.scad>;

SPLIT_PARTS = 0;
SHOW_LOWER = 1;
SHOW_UPPER = 1;

/*************
 * 3D Models *
 *************/
if (SHOW_LOWER) lower_main_case();
if (SHOW_UPPER) translate([0, 0, SPLIT_PARTS * 30]) upper_main_case();