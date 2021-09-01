include<tie.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module food_container() {
    tie_outer_radius = opening_size / 2; // radius of the tie part - forced by case.scad
    tie_tube_thickness = thickness / 2; // thickness of the tie part
    outer_radius = tie_outer_radius + thickness; // global radius - forced by case.scad
    inner_radius = tie_outer_radius - tie_tube_thickness;

    // tie to the spring container
    tube(tie_length, inner_radius, tie_outer_radius - inner_radius);
    tie(tie_length, tie_outer_radius, tie_thickness);

    // container slope
    difference() {
        hull() {
            translate([0, 0, -1]) cylinder(1, r=outer_radius);
            translate([food_container_width / 2, -outer_radius, -food_container_slope_height])
                rotate([0, 180, 0])
                    cube([food_container_width, food_container_depth, 1]);
        }
        hull() {
            translate([0, 0, -1]) cylinder(1, r=inner_radius);
            translate([food_container_width / 2 - thickness, -outer_radius + thickness, -food_container_slope_height])
                rotate([0, 180, 0])
                    cube([food_container_width - 2 * thickness, food_container_depth - 2 * thickness, 1]);
        }
    }

    // tie for extensions
    translate([0, food_container_depth / 2 - outer_radius, -food_container_slope_height - 1 - tie_length / 2]) {
        difference() {
            cube([food_container_width, food_container_depth, tie_length], center=true);
            cube([food_container_width - 2 * thickness, food_container_depth - 2 * thickness, tie_length], center=true);
            translate([0, 0, -tie_length / 2]) {
                translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
                rotate([0, 0, 180]) translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
                translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);
                rotate([0, 0, 180]) translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);
            }
        }
    }
}
module food_container_extension() {
    tie_tube_thickness = thickness / 2; // thickness of the male tie part

    // extension part
    translate([0, 0, -food_container_extension_height / 2]) {
        difference() {
            cube([food_container_width, food_container_depth, food_container_extension_height], center=true);
            cube([food_container_width - 2 * thickness, food_container_depth - 2 * thickness, food_container_extension_height], center=true);
            translate([0, 0, -food_container_extension_height / 2]) {
                translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
                rotate([0, 0, 180]) translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
                translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);
                rotate([0, 0, 180]) translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);
            }
        }
    }

    // male tie part
    translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
    rotate([0, 0, 180]) translate([food_container_width / 2 - thickness, 0, 0]) strait_tie(tie_length, tie_thickness);
    translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);
    rotate([0, 0, 180]) translate([0, food_container_depth / 2 - thickness, 0]) rotate([0, 0, 90]) strait_tie(tie_length, tie_thickness);

    // support for the male tie
    translate([0, 0, tie_length / 2]) {
        difference() {
            cube([food_container_width - 2 * thickness, food_container_depth - 2 * thickness, tie_length], center=true);
            cube([food_container_width - 2 * thickness - 2 * tie_tube_thickness, food_container_depth - 2 * thickness - 2 * tie_tube_thickness, tie_length], center=true);
        }
    }

}
