/*
 * Designed for tool caddy found at WM or auto parts stores with
 * center handle and a deep tray on either side.  Makes some of
 * the space useable for holding larger tools upright.
 */


bottomThickness=2;
wallThickness=1;

bottomWidth=70;
topWidth=100;

/*
crosswaysDividerOffsets=[0,15,30,60,100];  // last one cuts the remainder to outerLength
lengthWiseSplits=[
    [],[35],[],[20],[30]]; // same count as divider offsets - relative to bottomWidth
outerLength=150;
*/

crosswaysDividerOffsets=[0,20,70,120];  // last one cuts the remainder to outerLength
lengthWiseSplits=[
    [5,20,30,40,50,65],[25,55],[15,60],[40]]; // same count as divider offsets - relative to bottomWidth
outerLength=220;


innerLength=outerLength-wallThickness*2;

wallHeight=100;


$fn=50;
overlap=0.01;

// bottom
cube([bottomWidth,outerLength,bottomThickness]);

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
        taperedBox(bw=bottomWidth, tw=topWidth, bl=outerLength, tl=outerLength, ht=wallHeight+overlap);
    // cross slots
    //cutoutPositions=partialArraySum(crosswaysDividerOffsets);
    //echo(cutoutPositions);
    for (i=[0:1:len(crosswaysDividerOffsets)-1]) {
        //echo(cutoutPositions[i]);
        isFirstCutout=(i==0);
        isLastCutout=(i==(len(crosswaysDividerOffsets)-1));
        cutoutLength = ((!isLastCutout) ? // up to the penultimate item
            (crosswaysDividerOffsets[i+1]-crosswaysDividerOffsets[i]) :  // if there is another divider
            (innerLength-crosswaysDividerOffsets[i]))  // if this is the last divider
            - ((isFirstCutout || isLastCutout) ? wallThickness/2 : wallThickness);
        // echo(cutoutLength);
        //    outer wall + 1 more wall thickness after each pocket.
        yPosition = wallThickness + ((i==0) ? 0 : crosswaysDividerOffsets[i]+wallThickness/2);
        translate([wallThickness, yPosition, bottomThickness-overlap*2]) {
            difference() {
                taperedBox(bw=bottomWidth-wallThickness*2, tw=topWidth-wallThickness*2, 
                    bl=cutoutLength, tl=cutoutLength, 
                        ht=wallHeight+overlap*3);
                for (l=[0:1:len(lengthWiseSplits[i])-1]) {        
                    if (len(lengthWiseSplits[i]) != 0) {
                        translate([lengthWiseSplits[i][l]-wallThickness/2,-overlap,-overlap])
                            cube([wallThickness,cutoutLength+overlap*2,wallHeight+overlap*5]);
                    }
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