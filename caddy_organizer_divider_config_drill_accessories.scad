use <caddy_organizer_divider.scad>
use <caddy_organizer_divider_v2.scad>

// Custom Organizer for countersinks, drill stops, etc.
// to fit in a small "stackable" brand plastic box
// TODO: Vary the depth of each compartment (add platform/bottom height)
bottomThickness=2;
wallThickness=1;
bottomWidth=80;
topWidth=bottomWidth;
bottomLength=190;
topLength=bottomLength;
wallHeight=22;  // full height is 30 - shorter leaves room to grab items
dividerSpec = [
    [0, [[0,15],[27,15],[54,15]]],
    [12, [[0,0],[26,0],[52,0]]],
    [55, [[0,0],[22,0],[45,0],[64,0]]],
    [78, [[0,0],[20,0],[38,0]]],
    [120, [[0,0],[50,0]]]
];
// crosswaysDividerOffsets=[0,30,55,78,120];  // last one cuts the remainder to outerLength
// lengthwiseSplits=[
//     [45],[26,52],[22,45,64],[20,38],[60]]; // same count as divider offsets - relative to bottomWidth

//mirror([0,1,0]) // make everything configured left-to-right instead
    caddyOrganizerDividerAlt(bottomThickness=bottomThickness, wallThickness=wallThickness, 
        bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
        topLength=topLength, wallHeight=wallHeight,dividerSpec=dividerSpec);

//caddyOrganizerDividerAlt();        

//mirror([0,1,0]) // make everything configured left-to-right instead
    previewItems();

innerBoxWidthSpacing=10;
module previewItems() {
    // black drill collars
    translate([wallThickness+dividerSpec[0][1][0][0]+innerBoxWidthSpacing,wallThickness+10,10+bottomThickness+dividerSpec[0][1][0][1]])
        rotate([-90,0,0])
            color("gray")
                cylinder(d=20, h=9);
    translate([wallThickness+dividerSpec[0][1][1][0]+innerBoxWidthSpacing,wallThickness+10,10+bottomThickness+dividerSpec[0][1][1][1]])
        rotate([0,90,-90])
            color("gray")
                cylinder(d=20, h=9);
    translate([wallThickness+dividerSpec[0][1][2][0]+innerBoxWidthSpacing,wallThickness+10,10+bottomThickness+dividerSpec[0][1][2][1]])
        rotate([0,90,-90])
            color("gray")
                cylinder(d=20, h=9);
}