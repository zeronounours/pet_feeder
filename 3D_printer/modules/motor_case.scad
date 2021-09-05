include<motor.scad>

/***********
 * Modules *
 ***********/
module motor_case() {
    // part for the motor
    difference() {
        cylinder(total_motor_length, r=motor_case_radius);
        hull() {
            motor();
            translate([0, 0, total_motor_length]) motor();
        }
    }

    // Add a blocking back, while leaving space for wires
    translate([0, 0, total_motor_length]) intersection() {
        cylinder(thickness, r=motor_case_radius);
        translate([0, 0, thickness / 2]) cube([motor_width / 2, 2 * motor_case_radius, thickness], center=true);
    }

    // male part for the tie
    translate([0, 0, -thickness]) difference() {
        cylinder(thickness, r=motor_case_radius);
        translate([0, 0, -1]) cylinder(thickness + 2, r=motor_case_radius - thickness);
        translate([-motor_width / 2, -motor_case_radius, -1]) cube([motor_width, 2 * motor_case_radius, thickness + 2]);
    }
}
