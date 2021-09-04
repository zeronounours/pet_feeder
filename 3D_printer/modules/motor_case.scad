include<motor.scad>

/***********
 * Modules *
 ***********/
module motor_case() {
    // radius for the case
    case_radius = sqrt(motor_height * motor_height + motor_width * motor_width) / 2 + 2 * thickness;

    // part for the motor
    difference() {
        cylinder(motor_length + reduction_length, r=case_radius);
        hull() {
            motor();
            translate([0, 0, motor_length + reduction_length]) motor();
        }
    }

    // male part for the tie
    tie_length = thickness + 0.5;
    translate([0, 0, -tie_length]) difference() {
        cylinder(tie_length, r=case_radius);
        translate([0, 0, -1]) cylinder(tie_length + 2, r=case_radius - thickness);
        translate([-motor_width / 2, -case_radius, -1]) cube([motor_width, 2 * case_radius, tie_length + 2]);
    }
}
