use <caddy_organizer_divider.scad>

// 2nd config for clear utility box from Walmart
bottomWidth=91;
topWidth=98;
bottomLength=230;
topLength=238;
wallHeight=75;
crosswaysDividerOffsets=[0,55,80,140,165];
lengthwiseSplits=[
    [0,8,48],[0],[0,12,52],[0],[0]];

caddyOrganizerDivider(bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
    centerLengthwise=true, centerWidthwise=true,
    topLength=topLength, wallHeight=wallHeight,crosswaysDividerOffsets=crosswaysDividerOffsets,
    lengthwiseSplits=lengthwiseSplits,allFullDepth=true);

