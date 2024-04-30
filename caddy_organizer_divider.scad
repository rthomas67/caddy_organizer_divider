/*
 * Designed for tool caddy found at WM or auto parts stores with
 * center handle and a deep tray on either side.  Makes some of
 * the space useable for holding larger tools upright.
 */


bottomThickness=2;
wallThickness=1;


/*
// short, ~1/3 of the side pocket of the large aluminum bar handle caddy
bottomWidth=70;
topWidth=100;
wallHeight=100;
crosswaysDividerOffsets=[0,15,30,60,100];  // last one cuts the remainder to outerLength
lengthWiseSplits=[
    [],[35],[],[20],[30]]; // same count as divider offsets - relative to bottomWidth
bottomLength=150;
topLength=150;
*/

/*
// longer, ~1/2 of the side pocket of the large aluminum bar handle caddy
bottomWidth=70;
topWidth=100;
wallHeight=100;
crosswaysDividerOffsets=[0,20,70,120];  // last one cuts the remainder to outerLength
lengthWiseSplits=[
    [5,20,30,40,50,65],[25,55],[15,60],[60]]; // same count as divider offsets - relative to bottomWidth
bottomLength=220;
topLength=220;
*/

// For one of the clear utility boxes from walmart
bottomWidth=90;
topWidth=97;
wallHeight=80;
crosswaysDividerOffsets=[0,40,78,140,200];  // last one cuts the remainder to outerLength
lengthWiseSplits=[
    [24,48,72],[38,70],[40,80],[40],[30,60]]; // same count as divider offsets - relative to bottomWidth
bottomLength=230;
topLength=238;


innerLengthBottom=bottomLength-wallThickness*2;
innerLengthTop=topLength-wallThickness*2;
extraLengthTop=innerLengthTop-innerLengthBottom;

$fn=50;
overlap=0.01;

// bottom
cube([bottomWidth,bottomLength,bottomThickness]);

// See: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/List_Comprehensions
// Results in an array of the same number of elements as the input array (i=0 to len(valueArray))
// with each value set to the loop "counter" var total, which adds to the value it had from the previous iteration
// Not sure why total is initialized to a calculated value instead of just 0
// function partialArraySum(valueArray) = 
//     [for (
//         total=valueArray[0]-valueArray[0], i=0;
//         i<len(valueArray);
//         total=total+valueArray[i], i=i+1)
//             // cumulative off
//             [total+valueArray[i], ((i>=len(valueArray)) ? -1 : valueArray[i+1]-valueArray[i])]
//             ];

difference() {
    // outer shell - sides tapered, ends square 
    translate([0,0,bottomThickness-overlap])
        taperedBox(bw=bottomWidth, tw=topWidth, bl=bottomLength, tl=topLength, ht=wallHeight+overlap);
    // cross slots
    //cutoutPositions=partialArraySum(crosswaysDividerOffsets);
    //echo(cutoutPositions);
    for (i=[0:1:len(crosswaysDividerOffsets)-1]) {
        //echo(cutoutPositions[i]);
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
                    for (l=[0:1:len(lengthWiseSplits[i])-1]) {        
                        if (len(lengthWiseSplits[i]) != 0) {
                            translate([lengthWiseSplits[i][l]-wallThickness/2,-overlap,-overlap])
                                cube([wallThickness,cutoutLengthTop+overlap*2,wallHeight+overlap*5]);
                        }
                    } 
                }  // flip and shift everything
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