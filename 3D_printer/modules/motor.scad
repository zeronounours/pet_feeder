/***************
 * Computation *
 ***************/



/***********
 * Modules *
 ***********/
module motor(axis_length=motor_axis_len) {
    /*
     * Computation
     */

    // distance of the flat part of the axis from the center
    flat_distance = sqrt(motor_axis_rad * motor_axis_rad - motor_axis_flat_w * motor_axis_flat_w / 4);


    /*
     * Rendering
     */

    // Axis
    difference() {
        cylinder(axis_length, r=motor_axis_rad);
        translate([flat_distance, -motor_axis_rad, -1]) cube([2 * motor_axis_rad, 2 * motor_axis_rad, axis_length + 2]);
    }
    cylinder(0.5, r=motor_axis_rad + 0.5);

    // Reduction box
    translate([-motor_width / 2, -motor_height / 2, -reduction_length]) {
        difference() {
            cube([motor_width, motor_height, reduction_length]);
            translate([-1, -1, 1]) cube([motor_width + 2, motor_height + 2, (reduction_length - 3) / 2]);
            translate([-1, -1, (reduction_length - 3) / 2 + 2]) cube([motor_width + 2, motor_height + 2, (reduction_length - 3) / 2]);
        }
        translate([1, 1, 1]) cylinder((reduction_length - 3) / 2, 1);
        translate([motor_width - 1, motor_height - 1, 1]) cylinder((reduction_length - 3) / 2, 1);
        translate([motor_width - 1, 1, (reduction_length - 3) / 2 + 2]) cylinder((reduction_length - 3) / 2, 1);
        translate([1, motor_height - 1, (reduction_length - 3) / 2 + 2]) cylinder((reduction_length - 3) / 2, 1);
    }

    // motor
    translate([0, 0, -reduction_length - motor_length]) {
        intersection() {
            cylinder(motor_length, r=motor_width / 2);
            cube([motor_width, motor_height, 2 * motor_length], center=true);
        }
    }
}
