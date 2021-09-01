/*****************
 * Configuration *
 *****************/
/*
 * Global
 */

// Resolution
$fn = 40;


/*
 * Spinner
 */

// radius for the spinner (inner and outer)
external_radius = 35 / 2;
internal_radius = 20 / 2;

// pitch - distance between coils (real opening)
pitch = 25;

// length of the spring part
spring_length = 100;
// length of the attach part
attach_length = 20;

// spring resolution - in degrees
step = 5;


/*
 * Spinner container
 */

// Size of the hole for food input/output
opening_size = 40;

// thickness of sides
thickness = 2;

// tie length
tie_length = 10;
tie_thickness = thickness / 2;


/*
 * Motor
 */

// radius of the motor axis
motor_axis_rad = 1;

// radius of the motor
motor_radius = 12;

// length of the motor
motor_length = 20;


/*
 * Main case
 */

// dimensions
main_case_width = 140;
main_case_front_height = 150;
main_case_back_height = 230;
main_case_lower_depth = 100;
main_case_upper_depth = 20;

// dimensions for the from foot (for stability)
foot_height = 20;
foot_length = 100;

// back door
back_door_thickness = thickness;
back_door_height = main_case_back_height + 20;

// floor plates
floor_thickness = thickness;
floor_length = 90;

// supports for the arduino
arduino_support_height = 5;
arduino_support_radius = 6;
arduino_support_axis_height = 3;
arduino_support_axis_radius = 1.5;

// Height where to place the center of the spinner
spinner_height = 120;

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
