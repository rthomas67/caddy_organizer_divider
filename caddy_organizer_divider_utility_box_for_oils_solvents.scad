use <caddy_organizer_divider.scad>

// 2nd config for clear utility box from Walmart
bottomWidth=91;
topWidth=98;
bottomLength=230;
topLength=238;
wallHeight=75;
crosswaysDividerOffsets=[0,55,80,140,165];
lengthwiseSplits=[
    [8,48],[],[12,52],[],[]];

caddyOrganizerDivider(bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
    topLength=topLength, wallHeight=wallHeight,crosswaysDividerOffsets=crosswaysDividerOffsets,lengthwiseSplits=lengthwiseSplits);

