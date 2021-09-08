include<main_case.scad>;

/***********
 * Modules *
 ***********/
module food_container() {
    difference() {
        union () {
            // base shape for the main case
            main_case_base_shape(food_case_height, with_floor=false);
            // funnel
            intersection() {
                translate([0, input_hole_y, 0]) {
                    difference() {
                        union() {
                            cylinder(1, r=tube_radius_o);
                            hull() {
                                translate([0, 0, 1]) cylinder(1, r=tube_radius_o);
                                translate([0, 0, 0.5 + food_max_height])
                                        cube([2 * food_max_offset + 2 * tube_radius_o, 2 * food_max_offset + 2 * tube_radius_o, 1], center=true);
                            }
                        }
                        union() {
                            translate([0, 0, -1]) cylinder(3, r=tube_radius);
                            hull() {
                                translate([0, 0, 1]) cylinder(1, r=tube_radius);
                                translate([0, 0, 2 + food_max_height])
                                        cube([2 * food_max_offset + 2 * tube_radius, 2 * food_max_offset + 2 * tube_radius, 2], center=true);
                            }
                        }
                    }
                }
                // keep only what's inside the main_case
                translate([0, 0, (food_max_height + 1.5) / 2]) rounded_cube([main_case_width, main_case_depth, food_max_height + 1.5], main_case_corner_radius, center=true);
            }
        }
    }
}
module food_container_extension(with_pin=false) {
    difference() {
        main_case_base_shape(food_container_extension_height, with_floor=false);
        // Add the hole for pin if needed
        if (with_pin) {
            translate([main_case_width / 2, 0, food_container_extension_height / 2]) rotate([0, -90, 0]) cylinder(3 * thickness, r=pin_radius, center=true);
        }
    }
}
