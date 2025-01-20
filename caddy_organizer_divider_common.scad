overlap=0.01;

/*
 * separate h,w for top and bottom defines the taper
 * centering defines whether the extra on top or bottom extends fully in the positive direction,
 * or extends equally in both directions.
 * flip***Wise shifts the larger end (top or bottom) in the negative direction so it
 * doesn't need to be mirrored & shifted externally.
 * clipBottomHeight cuts off the lower part of the box up to the height specified
 */
module taperedBox(bw, tw, bl, tl, ht, centerWidthwise=true, centerLengthwise=true, 
        flipWidthwise=false, flipLengthwise=false,
        clipBottomHeight=0) {
    extraWidth = abs(tw-bw);
    extraLength = abs(tl-bl);
    widerWidth = max(tw,bw);
    longerLength = max(tl,bl);
    // Don't shift if not centered or flipped.  When not centered and flipped, shift negative direction
    topWidthShift = ((centerWidthwise) ? -(extraWidth/2) : ((flipWidthwise) ? -extraWidth : 0));
    topLengthShift = ((centerLengthwise) ? -(extraLength/2) : ((flipLengthwise) ? -extraLength : 0));
    echo(str("topWidthShift=",topWidthShift,", topLengthShift=",topLengthShift));
    difference() {
        hull() {
            translate([0,0,0]) 
                cube([bw,bl,overlap]);
            translate([topWidthShift,topLengthShift,ht+overlap])
                cube([tw,tl,overlap]);
        }
        // clip off the bottom of the box (when used as a shallow cutout)        
        translate([-widerWidth/2,-longerLength,-overlap])
            cube([widerWidth*2,longerLength*2,clipBottomHeight+overlap]);
    }
}