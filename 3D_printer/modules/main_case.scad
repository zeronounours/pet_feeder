include<tube.scad>;
include<motor_case.scad>;

/***********
 * Modules *
 ***********/
module rounded_cube(d, r, center=false) {
    minkowski() {
        cube([d.x - 2 * r, d.y - 2 * r, d.z / 2], center=center);
        // use a different cylinder, depending on whether it is centered
        if (center) cylinder(d.z / 2, r=r, center=center);
        else translate([r, r, 0]) cylinder(d.z / 2, r=r);
    }
}
module main_case_base_shape(height, with_floor=true) {
    floor_coef = with_floor ? 1: 0;
    translate([0, 0, height / 2]) difference() {
        rounded_cube([main_case_width, main_case_depth, height], r=main_case_corner_radius, center=true);
        rounded_cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, height + 1], r=main_case_corner_radius, center=true);
    }
    translate([0, 0, thickness - (main_case_tie_length + thickness) / 2]) difference() {
        rounded_cube([main_case_width - 2 * thickness, main_case_depth - 2 * thickness, main_case_tie_length + thickness], r=main_case_corner_radius, center=true);
        translate([0, 0, floor_coef * (-thickness - 1)]) rounded_cube([main_case_width - 4 * thickness, main_case_depth - 4 * thickness, main_case_tie_length + thickness + 1], r=main_case_corner_radius, center=true);
    }
}
module main_case() {
    difference() {
        main_case_base_shape(main_case_height, with_floor=true);
        // holes for wires to the lower case
        translate([0, wire_hole_y, -1]) cylinder(main_case_height, r=wire_hole_radius);
    }
}
