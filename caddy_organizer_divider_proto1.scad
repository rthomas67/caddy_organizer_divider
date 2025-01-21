use <caddy_organizer_divider.scad>

// short, ~1/3 of the side pocket of the large aluminum bar handle caddy
bottomWidth=70;
topWidth=100;
wallHeight=100;
crosswaysDividerOffsets=[0,15,30,60,100];
lengthwiseSplits=[[0],[0,35],[0],[0,20],[0,30]];
bottomLength=150;
topLength=150;

caddyOrganizerDivider(bottomWidth=bottomWidth, topWidth=topWidth, bottomLength=bottomLength, 
    topLength=topLength, wallHeight=wallHeight,crosswaysDividerOffsets=crosswaysDividerOffsets,
    lengthwiseSplits=lengthwiseSplits,allFullDepth=true);