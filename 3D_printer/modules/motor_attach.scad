/***********
 * Modules *
 ***********/
module motor_attach() {
    % rotate([180, 0, 0]) difference() {
        union() {
            // base
            cylinder(motor_attach_base_height, r=motor_attach_base_rad);
            // attach
            cylinder(motor_attach_total_height, r=motor_attach_attach_rad);
        }
        // Motor hole
        translate([0, 0, -1]) cylinder(motor_attach_total_height + 2, r=motor_attach_motor_hole_rad);
        // on base holes
        for(i=[0:3]) {
            rotate([0, 0, 90 * i])
                translate([0, motor_attach_hole_position_radius, -1])
                cylinder(motor_attach_base_height + 2, r=motor_attach_hole_rad);
        }
    }
}
