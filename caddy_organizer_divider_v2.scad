/*
 * Different construction using dividerSpec directly.
 */
use <caddy_organizer_divider_common.scad>

module caddyOrganizerDividerV2(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=55,
        bottomLength=75, topLength=80,
        wallHeight=25,
        dividerSpec=[
            [0,[[25,0]]],
            [30, [[15,0],[30,0]]]
        ]) {
    difference() {
        // Start with outer box full depth including extra for bottom thickness
        taperedBox();
    }


}