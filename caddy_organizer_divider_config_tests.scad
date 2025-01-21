use <caddy_organizer_divider.scad>

// test square sided more wide than long, thicker walls
// evenly split dividers
translate([-30,70,0])
caddyOrganizerDivider(bottomThickness=5, wallThickness=3, 
    bottomWidth=60, topWidth=60,
    bottomLength=30, topLength=30,
    wallHeight=20,
    crosswaysDividerOffsets=[0,10,20], // rows
    lengthwiseSplits=[[0,30],[0,20,40],[0]],  // row splits
    pocketDepths=[[10,10],[-1,10,15],[-1]]);  // how deep each pocket is

// test without pocket depths, but override to allFullDepth
// evenly split dividers
translate([50,0,0])
caddyOrganizerDivider(bottomThickness=1, wallThickness=1, 
    bottomWidth=60, topWidth=60,
    bottomLength=30, topLength=30,
    wallHeight=20,
    crosswaysDividerOffsets=[0,10,20], // rows
    lengthwiseSplits=[[0,30],[0,20,40],[0]],  // row splits
    allFullDepth=true);  // how deep each pocket is

// test exaggerated tapers
// moved below origin and centered to measure on grid marks
// 
translate([-30,-50,-30.05])
caddyOrganizerDivider(bottomThickness=1, wallThickness=1, 
    bottomWidth=60, topWidth=80,
    bottomLength=100, topLength=120,
    wallHeight=30,
    crosswaysDividerOffsets=[0,25,50,75], // rows
    lengthwiseSplits=[[0,30],[0,20,40],[0],[0,30]],  // row splits
    allFullDepth=true);  // how deep each pocket is

