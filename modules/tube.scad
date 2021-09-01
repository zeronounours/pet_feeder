/***********
 * Modules *
 ***********/
 module tube (h, inner_r, thick, closed=false) {
     difference() {
         cylinder(h, r=inner_r + thick);
         if(closed) {
             translate([0, 0, -1]) cylinder(h + 1 - thick, r=inner_r);

         } else {
            translate([0, 0, -1]) cylinder(h + 2, r=inner_r);
         }
     }
 }
