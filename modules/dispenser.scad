include<tie.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module dispenser() {
    tie_outer_radius = opening_size / 2; // radius of the tie part - forced by case.scad
    tie_thickness = thickness / 2; // thickness of the tie part
    outer_radius = tie_outer_radius + thickness; // global radius - forced by case.scad
    inner_radius = tie_outer_radius - tie_thickness;
    // tie to the spring container
    tube(tie_length, inner_radius, tie_thickness);
    tie(tie_length, tie_outer_radius, thickness / 2);
    // curved slop
    translate([0, 0, -1]) { // reclaim the heigth of the first cylinder
        difference() {
            hull() {
                cylinder(1, r=outer_radius);
                translate([0, outer_radius, -outer_radius]) rotate([-90, 0, 0]) cylinder(1, r=outer_radius);
            }
            hull() {
                cylinder(1, r=inner_radius);
                translate([0, outer_radius, -outer_radius]) rotate([-90, 0, 0]) cylinder(1, r=inner_radius);
            }
        }
    }
}

