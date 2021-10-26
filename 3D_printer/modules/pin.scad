/***********
 * Modules *
 ***********/
module rabbit_pin() {
    // extract the rabbit from the vendor stl file (remove half of it)
    difference() {
        rotate([0, 0, 180])
            translate([-30, 0, -30])
            import("vendor/origamix_rabbit.stl", convexity=10);
        translate([-500, 0, -500]) cube([1000, 1000, 1000]);
    }
    // add the pin
    rotate([-90, 0, 0]) cylinder(thickness, r=pin_radius);
}
