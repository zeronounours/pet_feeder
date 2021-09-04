/*****************
 * Configuration *
 *****************/
/*
 * Global
 */

// Resolution
$fn = 40;

// thickness of sides
thickness = 2;

/*
 * Spinner
 */

// radius for the spinner (inner and outer)
external_radius = 55 / 2;
internal_radius = 30 / 2;

// pitch - distance between coils (real opening)
pitch = 25;

// length of the spring part
spring_length = 140;
// length of the attach part
attach_length = 20;

// spring resolution - in degrees
step = 5;


/*
 * Spinner container
 */

// Size of the hole for food input/output
// It also define the size for the tube
opening_size = 60;

// Length for the spinner case
tube_length = spring_length + attach_length + thickness + opening_size / 2;

// Additional tube height: height added after the input hole (to prevent
// the spinner being stuck)
spinner_case_add_height = 40;

// tie length
tie_length = 10;
tie_thickness = thickness / 2;


/*
 * Motor
 */

// radius of the motor axis
motor_axis_rad = 1.5;
// width of the flat part of the motor axis (type D)
motor_axis_flat_w = 2;

// height of the motor (distance between the 2 flat edges)
motor_height = 10.5;
// width of the motor (distance between the 2 curved edges)
motor_width = 12.5;

// length of the motor
motor_length = 15;

// length of the reduction gearbox
reduction_length = 10;


/*
 * Main case
 */
// length of the bonds
main_case_tie_length = 5;

// dimensions
main_case_width = 140;
main_case_depth = 100;
main_case_height = opening_size + 2 * thickness;

// radius for the central hole
main_case_hole_radius = 5;

// supports for the arduino
arduino_support_height = 5;
arduino_support_radius = 6;
arduino_support_axis_height = 3;
arduino_support_axis_radius = 1.5;

// dimensions of the push button
button_radius = 3.5;
button_width = 11.5;
button_groove = thickness - 0.5;

// dimensions of the LED
led_radius = 2;
led_feet_width = 1;
led_groove = thickness / 2;

// distance between push button & led
control_panel_interval = 20;


/*
 * Food container
 */

// dimensions
food_container_width = main_case_width;
food_container_depth = food_container_width;
food_container_slope_height = 100;
food_container_extension_height = 100;

/*
 * Pin
 */
pin_radius = 1;
