use <caddy_organizer_divider.scad>

// For one of the clear utility boxes from Walmart
// Reminder: widths were adjusted after printing.  re-render before printing again
bottomWidth=91;
topWidth=98;
wallHeight=80;
crosswaysDividerOffsets=[0,40,78,140,180];  // last one cuts the remainder to outerLength
lengthwiseSplits=[
    [24,72],[38,70],[40,80],[40],[30,60]]; // same count as divider offsets - relative to bottomWidth
bottomLength=230;
topLength=238;

caddyOrganizerDivider(bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
    topLength=topLength, wallHeight=wallHeight,crosswaysDividerOffsets=crosswaysDividerOffsets,lengthwiseSplits=lengthwiseSplits);