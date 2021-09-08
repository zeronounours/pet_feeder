include<main_case.scad>;

/***********
 * Modules *
 ***********/
module food_container() {
    // compute height required in each direction to get slops to reach edges
    slope_height_y = tan(slopes_angle) * (main_case_depth / 2 - input_hole_y - tube_radius);
    slope_height_my = tan(slopes_angle) * (input_hole_y - tube_radius + main_case_depth / 2);
    // the hole is center in x direction, so the height is the same in both direction
    slope_height_x = tan(slopes_angle) * (main_case_width / 2 - tube_radius);
    // maximum height and offset
    max_height = max(slope_height_x, slope_height_my, slope_height_y);
    max_offset = max_height / tan(slopes_angle);
    // print the computed height
    echo(slope_height_y=slope_height_y);
    echo(slope_height_my=slope_height_my);
    echo(slope_height_x=slope_height_x);
    echo(max_height=max_height);
    echo(max_offset=max_offset);

    // height of the case
    case_height = max_height + main_case_tie_length + 2;
    echo(case_height=case_height);


    difference() {
        union () {
            // base shape for the main case
            main_case_base_shape(case_height, with_floor=false);
            // funnel
            intersection() {
                translate([0, input_hole_y, 0]) {
                    difference() {
                        union() {
                            cylinder(1, r=tube_radius_o);
                            hull() {
                                translate([0, 0, 1]) cylinder(1, r=tube_radius_o);
                                translate([0, 0, 0.5 + max_height])
                                        cube([2 * max_offset + 2 * tube_radius_o, 2 * max_offset + 2 * tube_radius_o, 1], center=true);
                            }
                        }
                        union() {
                            translate([0, 0, -1]) cylinder(3, r=tube_radius);
                            hull() {
                                translate([0, 0, 1]) cylinder(1, r=tube_radius);
                                translate([0, 0, 2 + max_height])
                                        cube([2 * max_offset + 2 * tube_radius, 2 * max_offset + 2 * tube_radius, 2], center=true);
                            }
                        }
                    }
                }
                // keep only what's inside the main_case
                translate([0, 0, (max_height + 1.5) / 2]) rounded_cube([main_case_width, main_case_depth, max_height + 1.5], main_case_corner_radius, center=true);
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
