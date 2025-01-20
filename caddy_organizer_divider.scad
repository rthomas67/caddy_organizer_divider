/*
 * Designed for tool caddy found at WM or auto parts stores with
 * center handle and a deep tray on either side.  Makes some of
 * the space useable for holding larger tools upright.
 *
 * TODO: Add support for outer rounded corners
 *
 */
use <caddy_organizer_divider_common.scad>

$fn=50;
overlap=0.01;

caddyOrganizerDivider(); // test defaults.

// translate([75,0,0])
//     caddyOrganizerDividerAlt(); // test defaults

// Show "missing zero offset element" bug
// translate([150,0,0])
//     caddyOrganizerDivider(crosswaysDividerOffsets=[30]);
    

// This does not work - https://learnxbyexample.com/openscad/structs/ is fabricated BS.
// section = [
//     "bottomWidth": 20,
//     "topWidth": 20,
//     "bottomLength": 10,
//     "topLength": 10,
//     "splits": [5, 15]
// ];

/*
 * Alternative way to specify each row of dividers with array of
 *  [ height, [[width,pocketDepth], [width,pocketDepth], [width,pocketDepth]] ],
 *  [ height, [[width,pocketDepth], [width,pocketDepth]] ],
 *  ...
 */
module caddyOrganizerDividerAlt(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=55,
        bottomLength=75, topLength=80,
        wallHeight=25,
        dividerSpec=[
            [0,[[25,0]]],
            [30, [[15,0],[30,0]]]
        ]) {
    crosswaysDividerOffsetsAlt=[
        for (i = [0:1:len(dividerSpec)-1]) dividerSpec[i][0]
    ];
    //echo(str("offsets: ", crosswaysDividerOffsetsAlt));

    crosswaysDividerLengthwiseSplitsAlt=[
        for (i = [0:1:len(dividerSpec)-1]) [
            for (j = [0:1:len(dividerSpec[i][1])-1]) dividerSpec[i][1][j][0]
        ]
    ];
    //echo(str("splits: ", crosswaysDividerLengthwiseSplitsAlt));

    pocketDepthsAlt = [
        for (i = [0:1:len(dividerSpec)-1]) [
            for (j = [0:1:len(dividerSpec[i][1])-1]) dividerSpec[i][1][j][1]
        ]
    ];
    echo(str("depths: ", pocketDepthsAlt));

    caddyOrganizerDivider(bottomThickness, wallThickness, 
        bottomWidth, topWidth,
        bottomLength, topLength,
        wallHeight,
        crosswaysDividerOffsets=crosswaysDividerOffsetsAlt,
        lengthwiseSplits=crosswaysDividerLengthwiseSplitsAlt,
        pocketDepths=pocketDepthsAlt);
}

// TODO: implement overcut left and overcut right for each pocket
// to overlap the sidewall.  Changing to cutting the pockets instead of
// not cutting the walls may make it way easier to understand and maintain.
// Maybe best to do this in v2

/*
 * Default wall thickness is subtracted from the width/length - i.e. The specified
 * dimensions are the "outer" dimension of the overall box.
 * Each offset is aligned with...
 * ALERT: The first element in the crosswaysDivider array is expected to be 0
 *  meaning the corresponding splits are against the first wall
 * ALERT: The first element in each split array is expected to be 0
 *  meaning the corresponding pocketDepth is against the first side
 */
 pocketCut=1;
module caddyOrganizerDivider(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=65,
        bottomLength=75, topLength=90,
        wallHeight=25,  // includes bottom thickness (REVIEW)
        crosswaysDividerOffsets=[0,30],
        lengthwiseSplits=[[0,25],[0,15,35]], // array of [offset,offset] for each cross section
        pocketDepths=[[5,10],[0,5,15]],
        centerLengthwise=true,
        centerWidthwise=true
        ) {

    // bottom
    cube([bottomWidth,bottomLength,bottomThickness]);

    difference() {
        // outer shell
        taperedBox(bw=bottomWidth, tw=topWidth, bl=bottomLength, tl=topLength, ht=wallHeight+overlap,
            centerLengthwise=centerLengthwise,
            centerWidthwise=centerWidthwise);

        // parameter checks / warnings
        if (crosswaysDividerOffsets[0] != 0)
            echo("Warning: First item in crosswaysDividerOffsets must be zero."); 

        if (pocketCut) {
            /*
             * WIP: Cut out each pocket 
             * (instead of subtracting lengthwise dividers from the crossways pockets, which is confusing)
             * Note: Inner walls (dividers and splits) are centered at the offset/position, so the wall thickness
             * consumes half from each adjacent pocket.
             * Note: The top width and length of the outer box is assumed to be larger
             *     than the bottom.  The offsets are based on the **bottom**, so the top overhangs
             *     (i.e. "tapers") **stick out** from what would otherwise be square sides.
             */
            // loop the dividers from end to end of the box
            totalTopLengthwiseExtra = (topLength - bottomLength);
            startingTopLengthwiseExtra = (totalTopLengthwiseExtra && centerLengthwise) ? totalTopLengthwiseExtra / 2 : 0;
            endingTopLengthwiseExtra = (totalTopLengthwiseExtra && centerLengthwise) ? totalTopLengthwiseExtra / 2 : totalTopLengthwiseExtra;
            startingInternalTopLengthwiseExtra = (startingTopLengthwiseExtra) ? startingTopLengthwiseExtra : 0;
            endingInternalTopLengthwiseExtra = (endingTopLengthwiseExtra) ? endingTopLengthwiseExtra : 0;
            
            totalTopWidthwiseExtra = (topWidth - bottomWidth);
            startingTopWidthwiseExtra = (totalTopWidthwiseExtra && centerWidthwise) ? totalTopWidthwiseExtra / 2 : 0;
            endingTopWidthwiseExtra = (totalTopWidthwiseExtra && centerWidthwise) ? totalTopWidthwiseExtra / 2 : totalTopWidthwiseExtra;
            startingInternalTopWidthwiseExtra = (startingTopWidthwiseExtra) ? startingTopWidthwiseExtra : 0;
            endingInternalTopWidthwiseExtra = (endingTopWidthwiseExtra) ? endingTopWidthwiseExtra : 0;
            
            for (i=[0:1:len(crosswaysDividerOffsets)-1]) {
                isFirstCrossSection=(i==0);
                isLastCrossSection=(i==(len(crosswaysDividerOffsets)-1));
                // outer wall --> divider position --> half of an inner wall = pocket cutout y-position
                lengthwiseOffset=crosswaysDividerOffsets[i]+((isFirstCrossSection) ? 0 : wallThickness/2);
                // at the ends calculate the extra length that will apply to the current cutout(s)
                lengthwiseExtra=(isFirstCrossSection) ? startingInternalTopLengthwiseExtra :
                    (isLastCrossSection) ? endingInternalTopLengthwiseExtra : 0;
                lengthwiseWallReduction = (isFirstCrossSection || isLastCrossSection) ? wallThickness / 2 : wallThickness;
                // There should ALWAYS be at least 1 split at zero offset to provide the bottom height
                for (l=[0:1:len(lengthwiseSplits[i])-1]) {
                    echo(str("i=",i,", l=",l," - lengthwiseOffset=",lengthwiseOffset,", lengthwiseSplits=",lengthwiseSplits[i]),
                        " - isFirstCrossSection=", isFirstCrossSection,", isLastCrossSection=",isLastCrossSection,
                        " - isFirstSplit=", isFirstSplit,", isLastSplit=",isLastSplit);
                    isFirstSplit=(l==0);
                    isLastSplit=(l==(len(lengthwiseSplits[i])-1)); 
                    widthwiseOffset=lengthwiseSplits[i][l] + ((isFirstSplit) ? 0 : wallThickness/2);
                    // outer segments reduce by 1/2 wall thickness
                    // inner segments reduce by 2 * 1/2 wall thicknesses (i.e. 1 whole)
                    widthwiseWallReduction = (isFirstSplit || isLastSplit) ? wallThickness / 2 : wallThickness;
                    widthwiseExtra = (isFirstSplit) ? startingInternalTopWidthwiseExtra :
                        (isLastSplit) ? endingInternalTopWidthwiseExtra : 0;

                    cutoutBl = ((isLastCrossSection) ? bottomLength : crosswaysDividerOffsets[i+1]) -
                            crosswaysDividerOffsets[i] - lengthwiseWallReduction;
                    cutoutBw = ((isLastSplit) ? bottomWidth : lengthwiseSplits[i][l+1]) - 
                            lengthwiseSplits[i][l] - widthwiseWallReduction;

                    cutoutTl = cutoutBl + lengthwiseExtra;
                    cutoutTw = cutoutBw + widthwiseExtra;

                    cutoutFlipLengthwise = isFirstCrossSection;
                    cutoutFlipWidthwise = isFirstSplit;
                    translate([widthwiseOffset,lengthwiseOffset,bottomThickness])
                        taperedBox(bl=cutoutBl, bw=cutoutBw, tl=cutoutTl, tw=cutoutTw,
                            ht=wallHeight+overlap,
                            centerWidthwise=false, centerLengthwise=false,
                            flipLengthwise=cutoutFlipLengthwise,
                            flipWidthwise=cutoutFlipWidthwise,
                            clipBottomHeight=pocketDepths[i][l]
                            );
                }
            } 
        } else {
            // OLD WAY.  Delete ASAP
            innerLengthBottom=bottomLength-wallThickness*2;
            innerLengthTop=topLength-wallThickness*2;
            extraLengthTop=innerLengthTop-innerLengthBottom;
            // loop the dividers from end to end of the box
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
                /*
                 * TODO: Use the extra pocketDepth values here...
                 * This creates a single object with multiple sections to cut out of 
                 * the crossways slice.  The walls are subtracted from the cutout.
                 * To support raised floors, the bottom portion of the area following the split
                 * up to the next wall needs to be subtracted off the bottom of the cutout object
                 * (i.e. leaving more of the outer box uncut).  This is done within the taperedBox
                 * module via the clipBottomHeight parameter.
                 */
                translate([wallThickness, yPosition, bottomThickness-overlap*2]) {
                    // flip and shift only the first block
                    translate([0,((isFirstCutout) ? cutoutLengthBottom : 0),0]) mirror([0,((isFirstCutout) ? 1 : 0),0]) {
                        difference() {
                            // Full crossways block cut out of outer shell
                            taperedBox(bw=bottomWidth-wallThickness*2, tw=topWidth-wallThickness*2, 
                                bl=cutoutLengthBottom, tl=cutoutLengthTop, 
                                    ht=wallHeight+overlap*3, centerLengthWise=false);
                            // subtract divider wall from the cutout for each split
                            if (len(lengthwiseSplits[i]) > 0) {  // only loop if there is at least 1 split
                                for (l=[0:1:len(lengthwiseSplits[i])-1]) {        
                                    if (lengthwiseSplits[i][l] > 0) {  // don't create a wall at the first / side-wall
                                        translate([lengthwiseSplits[i][l]-wallThickness/2,-overlap,-overlap])
                                            cube([wallThickness,cutoutLengthTop+overlap*2,wallHeight+overlap*5]);
                                    }
                                }
                            }
                            // TODO: Scrap this - too confusing to process separately
                            // subtract from how deep the floor is cut for each pocket
                            // TODO: Implement the side taper.  This only works for square sides.
                            for (l=[0:1:len(pocketDepths[i])-1]) {
                                currentSplitPosition=lengthwiseSplits[i][l];
                                isLastSplit=(l >= len(pocketDepths[i])-1);
                                nextSplitPosition=(isLastSplit) ? bottomWidth : lengthwiseSplits[i][l+1];
                                pocketWidth=nextSplitPosition-currentSplitPosition;
                                currentDividerPosition=crosswaysDividerOffsets[i];
                                nextDividerPosition=(isLastCutout) ? bottomLength : crosswaysDividerOffsets[i+1];
                                pocketLength=nextDividerPosition-currentDividerPosition;
                                if (len(pocketDepths[i]) != 0) {
                                    translate([lengthwiseSplits[i][l],crosswaysDividerOffsets[i]+wallThickness/2,bottomThickness-overlap*3])
                                        cube([pocketWidth,pocketLength,wallHeight-pocketDepths[i][l]]);
                                }
                            }

                        }
                    }
                }        
            }
        }
    }
}


