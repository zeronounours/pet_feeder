include<tie.scad>;
include<tube.scad>;

/***********
 * Modules *
 ***********/
module main_case() {
    // variables for spinner case tie
    tie_outer_radius = opening_size / 2; // radius of the tie part - forced by spinner_case.scad
    tie_tube_thickness = thickness / 2; // thickness of the tie part
    inner_radius = tie_outer_radius - tie_tube_thickness;
    // variables for floors and doors
    groove = thickness / 2;
    sliders_width = main_case_width - 2 * thickness + 2 * groove;

    // base shape of the case
    module base_shape() {
        linear_extrude(main_case_width) polygon([
            [0, 0], [main_case_lower_depth, 0],
            [main_case_lower_depth, main_case_front_height], [main_case_upper_depth, main_case_back_height],
            [0, main_case_back_height],
        ]);
    }
    difference() {
        union() {
            translate([-main_case_width / 2, 0, 0]) rotate([90, 0, 90]) {
                difference() {
                    base_shape();
                    // resize and translate for the inner extrusion
                    //      on x-axis, only 1 side has panel
                    translate([-thickness, thickness, thickness])
                        resize([main_case_lower_depth, main_case_back_height - 2 * thickness, main_case_width - 2 * thickness])
                        base_shape();
                }
            }

            // front foot for stability
            translate([0, main_case_lower_depth, 0]) {
                // only keep quater of a sphere
                intersection() {
                    resize([main_case_width, foot_length, foot_height]) sphere(1);
                    translate([-main_case_width / 2, 0, 0]) cube([main_case_width, foot_length, foot_height]);
                }
            }

            // spinner case tie
            translate([0, main_case_lower_depth, spinner_height]) rotate([-90, 0, 0]) {
                tube(tie_length, inner_radius, tie_tube_thickness);
                tie(tie_length, tie_outer_radius, tie_thickness);
            }

            // motor case
            translate([0, main_case_lower_depth - thickness, spinner_height]) rotate([90, 0, 0]) {
                difference() {
                    tube(motor_length, motor_radius, thickness);
                    cube([2 * (motor_radius + 2 * thickness), motor_radius / 2, spinner_height], center=true);
                }
            }
        }

        // motor axis hole
        translate([0, main_case_lower_depth - 1.5 * thickness, spinner_height]) rotate([-90, 0, 0]) cylinder(2 * thickness, r=motor_axis_rad * 1.5);

        // back door holes
        translate([-(main_case_width - 2 * thickness) / 2, 0, thickness]) cube([main_case_width - 2 * thickness, thickness, main_case_back_height]);
        translate([-sliders_width / 2, thickness, thickness - groove]) cube([sliders_width, back_door_thickness, main_case_back_height]);

        // floors
        translate([-sliders_width / 2, 0, 40 + thickness]) cube([sliders_width, main_case_lower_depth - thickness + groove, floor_thickness]);
        translate([-sliders_width / 2, 0, 80 + thickness]) cube([sliders_width, main_case_lower_depth - thickness + groove, floor_thickness]);
        translate([-sliders_width / 2, 0, 140 + thickness]) cube([sliders_width, main_case_lower_depth - thickness + groove, floor_thickness]);

        // push button holes
        control_panel_y_offset = (main_case_upper_depth + thickness + back_door_thickness) / 2;
        translate([-button_width / 2 - control_panel_interval / 2, control_panel_y_offset - button_width / 2, main_case_back_height - thickness]) cube([button_width, button_width, button_groove]);
        translate([-control_panel_interval / 2, control_panel_y_offset, main_case_back_height - thickness]) cylinder(thickness, r=button_radius);

        // led hole
        translate([control_panel_interval / 2, control_panel_y_offset, main_case_back_height - led_groove]) cylinder(led_groove, r=led_radius);
        translate([-led_radius + control_panel_interval / 2, control_panel_y_offset - led_feet_width / 2, main_case_back_height - thickness]) cube([2 * led_radius, led_feet_width, thickness]);
    }
}
