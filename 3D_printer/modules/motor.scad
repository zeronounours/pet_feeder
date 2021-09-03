/***************
 * Computation *
 ***************/



/***********
 * Modules *
 ***********/
module motor(axis_length=20, reduction_length=20) {
    /*
     * Computation
     */

    // distance of the flat part from the center
    flat_distance = sqrt(motor_axis_rad * motor_axis_rad - motor_axis_flat_w * motor_axis_flat_w / 4);


    /*
     * Rendering
     */

    // Axis
    difference() {
        cylinder(axis_length, r=motor_axis_rad);
        translate([flat_distance, -motor_axis_rad, -1]) cube([2 * motor_axis_rad, 2 * motor_axis_rad, axis_length + 2]);
    }

    // Reduction box
    translate([0, 0, -reduction_length/2]) cube([motor_width, motor_height, reduction_length], center=true);

    // motor
    translate([0, 0, -reduction_length - motor_length]) {
        intersection() {
            cylinder(motor_length, r=motor_height / 2);
            cube([motor_width, motor_height, 2 * motor_length], center=true);
        }
    }
}
