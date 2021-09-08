/*****************
 * Configuration *
 *****************/
/*
 * Global
 */

// Resolution
$fn = 60;

// thickness of sides
thickness = 2;

// tie length
tie_length = 10;
// thickness of the tie part
tie_thickness = thickness / 2;
// thickness of the support of the tie
tie_support_thickness = thickness / 2;

// size of the hole for food
opening_size = 60;

// angle for slopes for food (angle with horizontal plane)
slopes_angle = 45;


/*
 * Motor
 */

// radius of the motor axis
motor_axis_rad = 1.5;
// width of the flat part of the motor axis (type D)
motor_axis_flat_w = 2;
// length of the axis
motor_axis_len = 10;

// height of the motor (distance between the 2 flat edges)
motor_height = 10.5;
// width of the motor (distance between the 2 curved edges)
motor_width = 12.5;

// length of the motor
motor_length = 16;

// length of the reduction gearbox
reduction_length = 10;

/*
 * Main case
 */
// length of the bonds
main_case_tie_length = 5;

// dimensions
main_case_width = 170;
main_case_depth = 170;
main_case_height = 60;
main_case_corner_radius = 20;

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
 * Spinner
 */

// radius for the spinner (inner and outer)
external_radius = 55 / 2;
internal_radius = 30 / 2;

// pitch - distance between coils (real opening)
pitch = 25;

// length of the attach part
attach_length = 10;

// spring resolution - in degrees
step = 5;


/*
 * Spinner container
 */

// Additional tube height: height added after the input hole (to prevent
// the spinner being stuck)
spinner_case_add_height = 40;


/*
 * Food container
 */

// height for food container extension
food_container_extension_height = 100;

/*
 * Pin
 */
pin_radius = 1;

/***************
 * Computation *
 ***************/

// Total length of the motor
total_motor_length = motor_length + reduction_length;

// length of the motor case
motor_case_length = total_motor_length + thickness;
// radius for the motor case - computed to keep at least 1 thickness everywhere
motor_case_radius = sqrt(motor_height * motor_height + motor_width * motor_width) / 2 + 2 * thickness;


// length of the spring part
spring_length = main_case_depth - motor_case_length - 3 * thickness + opening_size / 3 - attach_length;

// inner radius of the spinner case tube
tube_radius = opening_size / 2;
// outer radius of the spinner case tube
tube_radius_o = tube_radius + thickness;

// Y position of the start of the spinner (attach part)
// Use the full size of the main case, minus the size required to place the
// motor
spinner_start_y = -main_case_depth / 2 + 3 * thickness + motor_case_length;

// Y position of the center of the input hole (in the spinner case)
input_hole_y =  spinner_start_y + attach_length + tube_radius;
// length of the tube of the spinner part (without the attach)
tube_length = main_case_depth / 2 - input_hole_y + tube_radius;

// dimension and position of the wire holes
//  radius is computed to fit the distance under the motor case
wire_hole_radius = (main_case_depth / 2 + spinner_start_y - 4 * thickness) / 2;
wire_hole_y = -main_case_depth / 2 + 2 * thickness + wire_hole_radius;

// height of the spinner case
spinner_case_height = 2 * tube_radius + spinner_case_add_height + thickness;

// Food container
// compute height required in each direction to get slopes to reach edges
food_slope_height_y = tan(slopes_angle) * (main_case_depth / 2 - input_hole_y - tube_radius);
food_slope_height_my = tan(slopes_angle) * (input_hole_y - tube_radius + main_case_depth / 2);
// the hole is center in x direction, so the height is the same in both direction
food_slope_height_x = tan(slopes_angle) * (main_case_width / 2 - tube_radius);
// maximum height and offset
food_max_height = max(food_slope_height_x, food_slope_height_my, food_slope_height_y);
food_max_offset = food_max_height / tan(slopes_angle);

// height of the food casecase
food_case_height = food_max_height + main_case_tie_length + 2;

// echo computed dimensions
echo(total_motor_length=total_motor_length);
echo(motor_case_length=motor_case_length);
echo(motor_case_radius=motor_case_radius);
echo(spring_length=spring_length);
echo(tube_radius=tube_radius);
echo(tube_radius_o=tube_radius_o);
echo(spinner_start_y=spinner_start_y);
echo(input_hole_y=input_hole_y);
echo(tube_length=tube_length);
echo(wire_hole_radius=wire_hole_radius);
echo(wire_hole_y=wire_hole_y);
echo(spinner_case_height=spinner_case_height);
echo(food_slope_height_y=food_slope_height_y);
echo(food_slope_height_my=food_slope_height_my);
echo(food_slope_height_x=food_slope_height_x);
echo(food_max_height=food_max_height);
echo(food_max_offset=food_max_offset);
echo(food_case_height=food_case_height);
