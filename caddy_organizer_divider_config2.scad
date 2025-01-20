use <caddy_organizer_divider.scad>
use <caddy_organizer_divider_v2.scad>

// longer, ~1/2 of the side pocket of the large aluminum bar handle caddy
bottomWidth=70;
topWidth=100;
wallHeight=100;
crosswaysDividerOffsets=[0,20,70,120];  // last one cuts the remainder to outerLength
lengthwiseSplits=[
    [5,20,30,40,50,65],[25,55],[15,60],[60]]; // same count as divider offsets - relative to bottomWidth
bottomLength=220;
topLength=220;

caddyOrganizerDivider(bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
    topLength=topLength, wallHeight=wallHeight,crosswaysDividerOffsets=crosswaysDividerOffsets,lengthwiseSplits=lengthwiseSplits);