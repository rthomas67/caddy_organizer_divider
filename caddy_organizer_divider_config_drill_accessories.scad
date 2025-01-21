use <caddy_organizer_divider.scad>
use <caddy_organizer_divider_v2.scad>

// Custom Organizer for countersinks, drill stops, etc.
// to fit in a small "stackable" brand plastic box
// TODO: Vary the depth of each compartment (add platform/bottom height)
bottomThickness=1.5;
wallThickness=1;
bottomWidth=80;
topWidth=bottomWidth;
bottomLength=190;
topLength=bottomLength;
// full height is 30, shorter leaves room to grab items
// * pocket depth + 8 should be < 30 - bottomThickness (28.5) total
// * pocket depth + 8 should be 
wallHeight=25; // this includes bottomThickness, so max pocket depth is this - bottomThickness
maxPocketDepth=wallHeight-bottomThickness;
div1=13.5; 
div2=div1+13;  // 12 + 1 for wall
div3=div2+13;  // 12 + 1 for wall
div4=div3+13;  // 12 + 1 for wall
div5=div4+13;  // 12 + 1 for wall
div6=div5+32;  // 31 + 1 for wall - after large red collar
div7=div6+24;  // 23 + 1 for wall - after small red collar
div8=div7+50;  // ?? + 1 for wall - after countersink bits
dividerSpec = [
    [0, [[0,18],[27,18],[54,18]]], // large steel drill stop collars (vertical)
    [div1, [[0,16],[23,15],[45,13],[65,8]]], // smaller steel drill stop collars (vertical)
    [div2, [[0,maxPocketDepth],[33,22],[63,-1]]], // aluminum drill stop collars (vertical)
    [div3, [[0,20],[28,16],[54,14]]], // aluminum drill stop collars (vertical)
    [div4, [[0,14],[23,13],[45,12],[66,-1]]], // aluminum drill stop collars (vertical)
    [div5, [[0,maxPocketDepth],[50,-1]]], // large aluminum red drill stop
    [div6, [[0,18],[36,-1]]],  // small aluminum red drill stop
    [div7, [[0,17],[22.5,14],[42,10],[58,8],[70,6]]], // countersink bits
    [div8, [[0,-1]]], // last opening - remainder
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

innerBoxLengthSpacing=1;
innerBoxWidthSpacing=2;
innerBoxWidthSpacing2=1;
module previewItems() {
    translate([wallThickness,wallThickness,bottomThickness]) {  // inset everything by side wall thickness & bottom at once
        // black drill collars
        translate([dividerSpec[0][1][0][0]+innerBoxWidthSpacing,dividerSpec[0][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[0][1][0][1]])
            verticalDiskAtOrigin(d=20, h=9);
        translate([dividerSpec[0][1][1][0]+innerBoxWidthSpacing,dividerSpec[0][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[0][1][1][1]])
            verticalDiskAtOrigin(d=20, h=9);
        translate([dividerSpec[0][1][2][0]+innerBoxWidthSpacing,dividerSpec[0][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[0][1][2][1]])
            verticalDiskAtOrigin(d=20, h=9);
        
        // smaller black drill stop collars
        translate([dividerSpec[1][1][0][0]+innerBoxWidthSpacing,dividerSpec[1][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[1][1][0][1]])
            verticalDiskAtOrigin(d=18, h=9);
        translate([dividerSpec[1][1][1][0]+innerBoxWidthSpacing,dividerSpec[1][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[1][1][1][1]])
            verticalDiskAtOrigin(d=17, h=9);
        translate([dividerSpec[1][1][2][0]+innerBoxWidthSpacing,dividerSpec[1][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[1][1][2][1]])
            verticalDiskAtOrigin(d=15, h=9);
        translate([dividerSpec[1][1][3][0]+innerBoxWidthSpacing,dividerSpec[1][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[1][1][3][1]])
            verticalDiskAtOrigin(d=10, h=9);

        // aluminum drill collars row 1
        translate([dividerSpec[2][1][0][0]+innerBoxWidthSpacing,dividerSpec[2][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[2][1][0][1]])
            verticalDiskAtOrigin(d=28, h=9, c="silver");  // 1/2
        translate([dividerSpec[2][1][1][0]+innerBoxWidthSpacing,dividerSpec[2][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[2][1][1][1]])
            verticalDiskAtOrigin(d=24.5, h=9, c="silver"); // 7/16
        // 3rd slot open on this row
        
        // aluminum drill collars row 2
        translate([dividerSpec[3][1][0][0]+innerBoxWidthSpacing,dividerSpec[3][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[3][1][0][1]])
            verticalDiskAtOrigin(d=22, h=9, c="silver");  // 3/8
        translate([dividerSpec[3][1][1][0]+innerBoxWidthSpacing,dividerSpec[3][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[3][1][1][1]])
            verticalDiskAtOrigin(d=19, h=9, c="silver");  // 5/16
        translate([dividerSpec[3][1][2][0]+innerBoxWidthSpacing,dividerSpec[3][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[3][1][2][1]])
            verticalDiskAtOrigin(d=18.4, h=9, c="silver");  // 1/4

        // aluminum drill collars row 3
        translate([dividerSpec[4][1][0][0]+innerBoxWidthSpacing,dividerSpec[4][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[4][1][0][1]])
            verticalDiskAtOrigin(d=17, h=9, c="silver");  // 7/32
        translate([dividerSpec[4][1][1][0]+innerBoxWidthSpacing,dividerSpec[4][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[4][1][1][1]])
            verticalDiskAtOrigin(d=16, h=9, c="silver");  // 3/16
        translate([dividerSpec[4][1][2][0]+innerBoxWidthSpacing,dividerSpec[4][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[4][1][2][1]])
            verticalDiskAtOrigin(d=15, h=9, c="silver");  // 1/8

        // red aluminum drill collar large
        translate([dividerSpec[5][1][0][0]+innerBoxWidthSpacing,dividerSpec[5][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[5][1][0][1]])
            translate([0,28,0])
                rotate([0,0,-90])
                    verticalDiskAtOrigin(d=28, h=43, c="red");  // 7/32

        // red aluminum drill collar large
        translate([dividerSpec[6][1][0][0]+innerBoxWidthSpacing,dividerSpec[6][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[6][1][0][1]])
            translate([0,19,0])
                rotate([0,0,-90])
                    verticalDiskAtOrigin(d=19, h=30.3, c="red");  // 7/32

        // countersink bits
        translate([dividerSpec[7][1][0][0]+innerBoxWidthSpacing2,dividerSpec[7][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[7][1][0][1]])
            verticalDiskAtOrigin(d=19, h=47);
        translate([dividerSpec[7][1][1][0]+innerBoxWidthSpacing2,dividerSpec[7][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[7][1][1][1]])
            verticalDiskAtOrigin(d=16, h=43.6);
        translate([dividerSpec[7][1][2][0]+innerBoxWidthSpacing2,dividerSpec[7][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[7][1][2][1]])
            verticalDiskAtOrigin(d=12.6, h=42.5);
        translate([dividerSpec[7][1][3][0]+innerBoxWidthSpacing2,dividerSpec[7][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[7][1][3][1]])
            verticalDiskAtOrigin(d=9.5, h=41.6);
        translate([dividerSpec[7][1][4][0]+innerBoxWidthSpacing2,dividerSpec[7][0]+innerBoxLengthSpacing,
                wallHeight-dividerSpec[7][1][4][1]])
            verticalDiskAtOrigin(d=6.3, h=40.1);
    }
}

module verticalDiskAtOrigin(d=1, h=1, c="gray") {
    color(c)
        translate([d/2,0,d/2])
            rotate([-90,0,0])
                cylinder(d=d, h=h);
}