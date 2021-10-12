include<main_case.scad>;

/***********
 * Modules *
 ***********/
module lid() {
    difference() {
        main_case_base_shape(thickness, with_floor=true);
        // Add the hole to open the lid
        translate([0, 0, -thickness]) cylinder(3 * thickness, r=lid_hole_radius);
    }
}

