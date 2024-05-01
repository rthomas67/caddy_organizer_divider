/*
 * Designed for tool caddy found at WM or auto parts stores with
 * center handle and a deep tray on either side.  Makes some of
 * the space useable for holding larger tools upright.
 */

$fn=50;
overlap=0.01;

caddyOrganizerDivider(); // test defaults.

// Show "missing zero offset element" bug
translate([75,0,0])
    caddyOrganizerDivider(crosswaysDividerOffsets=[30]);
    

module caddyOrganizerDivider(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=55,
        bottomLength=75, topLength=80,
        wallHeight=25,
        crosswaysDividerOffsets=[0,30],
        lengthwiseSplits=[[25],[15,35]]) {

    innerLengthBottom=bottomLength-wallThickness*2;
    innerLengthTop=topLength-wallThickness*2;
    extraLengthTop=innerLengthTop-innerLengthBottom;
    // bottom
    cube([bottomWidth,bottomLength,bottomThickness]);

    difference() {
        // outer shell - sides tapered, ends square 
        translate([0,0,bottomThickness-overlap])
            taperedBox(bw=bottomWidth, tw=topWidth, bl=bottomLength, tl=topLength, ht=wallHeight+overlap);
        // cross slots

        if (crosswaysDividerOffsets[0] != 0)
            echo("Warning: First item in crosswaysDividerOffsets must be zero.");
        // TODO: Fix logic when crosswaysDividers does not have 0 as its first value.

        for (i=[0:1:len(crosswaysDividerOffsets)-1]) {
            isFirstCutout=(i==0);
            isLastCutout=(i==(len(crosswaysDividerOffsets)-1));
            cutoutLengthBottom = ((!isLastCutout) ? // up to the penultimate item
                (crosswaysDividerOffsets[i+1]-crosswaysDividerOffsets[i]) :  // if there is another divider
                (innerLengthBottom-crosswaysDividerOffsets[i]))  // if this is the last divider
                - ((isFirstCutout || isLastCutout) ? wallThickness/2 : wallThickness);
            cutoutLengthTop = ((!isLastCutout) ? // up to the penultimate item
                (crosswaysDividerOffsets[i+1]-crosswaysDividerOffsets[i]) :  // if there is another divider, length is next offset - this offset
                (innerLengthBottom-crosswaysDividerOffsets[i]))  // if this is the last divider
                + ((isFirstCutout || isLastCutout) ? extraLengthTop/2 : 0)
                - ((isFirstCutout || isLastCutout) ? wallThickness/2 : wallThickness);
            // echo(cutoutLengthBottom);
            //    outer wall + 1 more wall thickness after each pocket.
            yPosition = wallThickness + ((i==0) ? 0 : crosswaysDividerOffsets[i]+wallThickness/2);
            translate([wallThickness, yPosition, bottomThickness-overlap*2]) {
                // flip and shift only the first block
               translate([0,((isFirstCutout) ? cutoutLengthBottom : 0),0]) mirror([0,((isFirstCutout) ? 1 : 0),0]) {
                difference() {
                    // crossways block
                        taperedBox(bw=bottomWidth-wallThickness*2, tw=topWidth-wallThickness*2, 
                            bl=cutoutLengthBottom, tl=cutoutLengthTop, 
                                ht=wallHeight+overlap*3, centerLengthWise=false);
                        for (l=[0:1:len(lengthwiseSplits[i])-1]) {        
                            if (len(lengthwiseSplits[i]) != 0) {
                                translate([lengthwiseSplits[i][l]-wallThickness/2,-overlap,-overlap])
                                    cube([wallThickness,cutoutLengthTop+overlap*2,wallHeight+overlap*5]);
                            }
                        } 
                    }  // flip and shift everything
                }
            }        
        }
    }
}


module taperedBox(bw, tw, bl, tl, ht, centerWidthWise=true, centerLengthWise=true) {
    hull() {
        translate([0,0,0])
            cube([bw,bl,overlap]);
        translate([((centerWidthWise) ? -(abs(tw-bw)/2) : 0), ((centerLengthWise) ? -(abs(tl-bl)/2) : 0),ht-overlap])
            cube([tw,tl,overlap]);
    }
}