include<tie.scad>;
include<tube.scad>;

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
// module for the openings
module openings(tie_length, inner_r, tube_r, thick, add_height=0) {
    difference() {
        tube(tie_length + tube_r + add_height, inner_r, thick);
        // remove the part inside the container cylinder
        rotate([90, 0, 0]) cylinder(2 * (inner_r + thick), r=tube_r, center=true);
        // tie
        translate([0, 0, tie_length + tube_r + add_height]) rotate([180, 0, 0]) tie_r(tie_length, tube_r, tie_thickness);
    }
}

// spring container
module spring_container() {
    // Variables for the container
    input_z = attach_length + opening_size / 2;
    output_z = tube_length - opening_size / 2 - thickness;

    difference() {
        // main shape for the container - it is a 2 level pipe, like:
        //
        //        +-------------+
        //        |             |
        //   +----+.............|
        //   |                  |
        //   +------------------+
        //
        union() {
            // starting, simple 1-level tube
            tube(input_z, tube_radius, thickness);
            // 2-level tube
            translate([0, 0, input_z]) {
                difference() {
                    // external shape
                    hull() {
                        cylinder(tube_length - input_z, r=tube_radius + thickness);
                        translate([0, -spinner_case_add_height, 0]) cylinder(tube_length - input_z, r=tube_radius + thickness);
                    }
                    // internal extrusion
                    translate([0, 0, -1]) hull() {
                        cylinder(tube_length - input_z - thickness + 1, r=tube_radius);
                        translate([0, -spinner_case_add_height, 0]) cylinder(tube_length - input_z - thickness + 1, r=tube_radius);
                    }
                }
            }
        }
        // input hole
        translate([0, 0, input_z]) rotate([90, 0, 0]) cylinder(tube_radius * 2 + spinner_case_add_height, r=opening_size / 2);
        // output hole
        translate([0, 0, output_z]) rotate([-90, 0, 0]) cylinder(tube_radius * 2, r=opening_size / 2);
        // tie
        tie_r(tie_length, tube_radius, tie_thickness);
    }
    // input attach
    difference() {
        translate([0, 0, input_z]) rotate([90, 0, 0]) openings(tie_length, opening_size / 2, tube_radius, thickness, spinner_case_add_height - tie_length + thickness);
        // remove the part of the upper tube to prevent stucking
        translate([0, 0, input_z]) hull() {
            cylinder(opening_size / 2 + thickness, r=tube_radius);
            translate([0, -spinner_case_add_height, 0]) cylinder(opening_size / 2 + thickness, r=tube_radius);
        }
    }
    // output attach
    translate([0, 0, output_z]) rotate([-90, 0, 0]) openings(tie_length, opening_size / 2, tube_radius, thickness);
}
