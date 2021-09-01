/*****************
 * Configuration *
 *****************/
// width for the L of the tie
L_width = 3;
// detach length for the L of the tie
L_detach = 6;

/***********
 * Modules *
 ***********/
// Module to create a rounded L
module L(h, add_offset=0) {
    union() {
        hull() {
            square(L_width, center=true);
            translate([0, -add_offset, 0]) square(L_width, center=true);
            translate([h - L_width / 2, 0, 0]) circle(L_width / 2);
            translate([h - L_width / 2, -add_offset, 0]) circle(L_width / 2);
        }
        hull() {
            translate([h - L_width / 2, 0, 0]) circle(L_width / 2);
            translate([h - L_width / 2, L_detach - L_width / 2 , 0]) circle(L_width / 2);
        }
    }
}
// module to create a spinning tie with custom form
module tie_with(h, r, thick) {
    intersection() {
        // extruded cylinder to hold the L
        difference() {
            cylinder(h, r=r + thick);
            translate([0, 0, -1]) cylinder(h+2, r=r);
        }
        // 2 L to perform the tie
        union() {
            children();
            rotate([0, 0, 180]) children();
        }
    }
}
// module to create a spinning tie
module tie(h, r, thick) {
    tie_with(h, r, thick) rotate([0, -90, 0]) linear_extrude(r + 2 * thick) L(h);
}
// reverse module of the spinning tie: use it to diff a solid which must
// accept the spinning tie
module tie_r(h, r, thick) {
    // use a L with the vertical bar larger
    tie_with(h, r, thick) rotate([0, -90, 0]) linear_extrude(r + 2 * thick) L(h, L_detach);
}
