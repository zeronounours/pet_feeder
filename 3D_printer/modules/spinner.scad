include<motor.scad>;

/***************
 * Computation *
 ***************/
/*
 * Spinner
 */
// radius of spring
radius = (internal_radius + external_radius) / 2;
 // radius of wire
wire_radius = (external_radius - internal_radius) / 2;
// pitch of spring - real distance betweens coil centers
real_pitch = pitch + 2 * wire_radius;
// number of coils
coils = spring_length / real_pitch;


/***********
 * Modules *
 ***********/
/*
 * Tube module
 * From https://github.com/KitWallace/openscad/blob/master/spring.scad
 */
module spring(radius, wire_rad, coils, pitch, step=5) {

    function m_translate(v) = [ [1, 0, 0, 0],
                                [0, 1, 0, 0],
                                [0, 0, 1, 0],
                                [v.x, v.y, v.z, 1  ] ];

    function m_rotate(v) =  [ [1,  0,         0,        0],
                              [0,  cos(v.x),  sin(v.x), 0],
                              [0, -sin(v.x),  cos(v.x), 0],
                              [0,  0,         0,        1] ]
                          * [ [ cos(v.y), 0,  -sin(v.y), 0],
                              [0,         1,  0,        0],
                              [ sin(v.y), 0,  cos(v.y), 0],
                              [0,         0,  0,        1] ]
                          * [ [ cos(v.z),  sin(v.z), 0, 0],
                              [-sin(v.z),  cos(v.z), 0, 0],
                              [ 0,         0,        1, 0],
                              [ 0,         0,        0, 1] ];

    function vec3(v) = [v.x, v.y, v.z];
    function transform(v, m)  = vec3([v.x, v.y, v.z, 1] * m);

    function orientate(p0, p) =
                  m_rotate([0, atan2(sqrt(pow(p[0], 2) + pow(p[1], 2)), p[2]), 0])
                * m_rotate([0, 0, atan2(p[1], p[0])])
                * m_translate(p0);

    function loop_points(step, end, t=0) =
        t <= end
           ? concat([f(t)], loop_points(step, end, t + step))
           : [] ;

    function transform_points(list, matrix, i=0) =
        i < len(list)
           ? concat([ transform(list[i], matrix) ], transform_points(list, matrix, i + 1))
           : [];

    function tube_points(loop_points, section_points, i=0) =
        i < len(loop_points) - 1
           ? concat(
               transform_points(
                     section_points,
                     orientate(loop_points[i], (loop_points[i + 1] - loop_points[i]) / 2)),
              tube_points(loop_points,section_points, i + 1)
            )
           : []    // in a closed loop, this segment connects to the start
    ;

    function tube_faces(facets, s, i=0) =
         i < facets
           ?  concat([[s * facets + i,
                       s * facets + (i + 1) % facets,
                      (s + 1) * facets + (i + 1) % facets,
                      (s + 1) * facets + i]
                    ],
                    tube_faces(facets, s, i + 1))
          : [];

    function tube_end(facets, s, i=0) =
         i < facets
           ?  concat( [s * facets + i], tube_end(facets, s, i + 1))
           : [];


    function loop_faces(segs, facets, j=0) =
         j < segs
            ? concat(tube_faces(facets,  j), loop_faces(segs, facets, j + 1))
            : [];

    function loop_all_faces(segs, facets) =
         concat ([reverse(tube_end(facets, 0))], // direction changed here
                  loop_faces(segs, facets),
                 [tube_end(facets, segs)]
                );

    function reverse_r(v, n) =
          n == 0
            ? [v[0]]
            : concat([v[n]], reverse_r(v, n - 1))
    ;
    function reverse(v) = reverse_r(v, len(v) - 1);


    function circle_points(r=1, i=0) =
        let (
            flat_a = asin(thickness / 2 / r),
            a = flat_a + (360 - 2 * flat_a) / $fn * i
        )
        i <= $fn
           ? concat([[r * sin(a), -r * cos(a), 0]], circle_points(r, i + 1))
           : [[-thickness / 2, -radius, 0], [thickness / 2, -radius, 0]] ;

    function f(t) =  [radius * sin(t), radius * cos(t), pitch * t / 360 ];

    function loop_points(step, end, t = 0) =
        t <= end
           ? concat([f(t)], loop_points(step, end, t + step))
           : [] ;

    section_points = circle_points(wire_rad);

    loop_points = loop_points(step, 360 * coils + step);
    tube_points = tube_points(loop_points, section_points);

    faces = loop_all_faces(len(loop_points) - 2, len(section_points));
    polyhedron(points=tube_points, faces=faces);
}

module spinner() {
    // spring
    rotate([0, 0, 45]) translate([0, 0, wire_radius]) spring(radius, wire_radius, coils, real_pitch, step=step);
    // axis
    cylinder(spring_axis_length, r=roller_inner_radius);
    // edge for roller
    hull() {
        // make it in a shape of a cone to be printable
        translate([0, 0, spring_axis_length - roller_length - roller_edge]) cylinder(roller_edge, r=roller_inner_radius + roller_edge);
        translate([0, 0, spring_axis_length - roller_length - 2 * roller_edge]) cylinder(roller_edge, r=roller_inner_radius);
    }
    // base
    difference() {
        union () {
            // base with holes
            cylinder(thickness, r=radius + wire_radius);
            // edges going back
            back_length = motor_attach_total_height - attach_length + roller_edge;
            translate([0, 0, -back_length]) difference() {
                cylinder(back_length, r=radius + wire_radius);
                translate([0, 0, -1]) cylinder(back_length + 2, r=radius + wire_radius - thickness);
            }
        }
        // holes on the base to match motor_attach holes
        for(i=[0:3]) {
            rotate([0, 0, 90 * i])
                translate([0, motor_attach_hole_position_radius, -1])
                cylinder(thickness + 2, r=motor_attach_hole_rad);
        }
    }
}

module food() {
    % rotate([45, 45, 45]) cylinder(25, r=3);
}
