/***********
 * Modules *
 ***********/
module rabbit_pin() {
    // extract the rabbit from the vendor stl file (remove half of it)
    translate([-30, 0, -30]) difference() {
        import("vendor/origamix_rabbit.stl");
        translate([-10, 0, 0]) cube([1000, 1000, 1000]);
    }
    // add the pin
    rotate([-90, 0, 0]) cylinder(thickness, r=pin_radius);
}
