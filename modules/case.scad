include<tie.scad>;

/***************
 * Computation *
 ***************/
/*
 * spring container
 */
tube_length = (spring_length + attach_length + thickness) * 1.1;
tube_radius = opening_size / 2;

/***********
 * Modules *
 ***********/
 module tube (h, inner_r, thick, closed=false) {
     difference() {
         cylinder(h, r=inner_r + thick);
         if(closed) {
             translate([0, 0, -1]) cylinder(h + 1 - thick, r=inner_r);

         } else {
            translate([0, 0, -1]) cylinder(h + 2, r=inner_r);
         }
     }
 }

// module for the openings
module openings(tie_length, inner_r, tube_r, thick) {
    difference() {
        tube(tie_length + tube_r, inner_r, thick);
        // remove the part inside the container cylinder
        rotate([90, 0, 0]) cylinder(2 * (inner_r + thick), r=tube_r, center=true);
        // tie
        translate([0, 0, tie_length + tube_r]) rotate([180, 0, 0]) tie_r(tie_length, tube_r, thick / 2);
    }
}

// spring container
module spring_container() {
    difference() {
        tube(tube_length, tube_radius, thickness, closed=true);
        // input hole
        translate([0, 0, attach_length + opening_size / 2]) rotate([90, 0, 0]) cylinder(tube_radius * 2, r=opening_size / 2);
        // output hole
        translate([0, 0, tube_length - opening_size / 2 - thickness]) rotate([-90, 0, 0]) cylinder(tube_radius * 2, r=opening_size / 2);
        // tie
        tie_r(tie_length, tube_radius, thickness / 2);
    }
    // input attach
    translate([0, 0, attach_length + opening_size / 2]) rotate([90, 0, 0]) openings(tie_length, opening_size / 2, tube_radius, thickness);
    // output attach
    translate([0, 0, tube_length - opening_size / 2 - thickness]) rotate([-90, 0, 0]) openings(tie_length, opening_size / 2, tube_radius, thickness);
}
