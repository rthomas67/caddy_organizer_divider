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

// TODO: implement overcut left and overcut right for each pocket
// to overlap the sidewall.  Changing to cutting the pockets instead of
// not cutting the walls may make it way easier to understand and maintain.

/*
 * This is the primary module for creating a divided box for printing.
 *
 * Default wall thickness is subtracted from the width/length - i.e. The specified
 * dimensions are the "outer" dimension of the overall box.
 * Each offset is aligned with...
 * ALERT: The first element in the crosswaysDivider array is expected to be 0
 *  meaning the corresponding splits are against the first wall
 * ALERT: The first element in each split array is expected to be 0
 *  meaning the corresponding pocketDepth is against the first side
 */
caddyOrganizerDivider(); // test defaults.
module caddyOrganizerDivider(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=65,
        bottomLength=75, topLength=90,
        wallHeight=25,  // includes bottom thickness (REVIEW)
        crosswaysDividerOffsets=[0,30],
        lengthwiseSplits=[[0,25],[0,15,35]], // array of [offset,offset] for each cross section
        pocketDepths=[[5,10],[-1,5,15]],
        centerLengthwise=true,
        centerWidthwise=true,
        allFullDepth=false
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
            // either 0 + outer wall thickness, or offsetPosition (center of wall) + 1/2 (inner) wall thickness
            lengthwiseOffset=crosswaysDividerOffsets[i]+((isFirstCrossSection) ? wallThickness : wallThickness/2);
            // at the ends calculate the extra length that will apply to the current cutout(s)
            lengthwiseExtra=extraAmount(isFirstCrossSection, isLastCrossSection, startingInternalTopLengthwiseExtra,
                    endingInternalTopLengthwiseExtra);
            // lengthwiseExtra=(isFirstCrossSection) ? startingInternalTopLengthwiseExtra :
            //     (isLastCrossSection) ? endingInternalTopLengthwiseExtra : 0;
            lengthwiseWallReduction = (isFirstCrossSection && isLastCrossSection) ? 
                    wallThickness * 2 : // no dividers (i.e. only the 0 divider), but both outer side walls
                    (isFirstCrossSection || isLastCrossSection) ? 
                        wallThickness + wallThickness / 2 : // one outer end wall and 1/2 inner divider
                        wallThickness;  // 1/2 in inner divider wall, twice
            // There should ALWAYS be at least 1 split at zero offset to provide the bottom height
            for (l=[0:1:len(lengthwiseSplits[i])-1]) {
                echo(str("i=",i,", l=",l," - lengthwiseOffset=",lengthwiseOffset,", lengthwiseSplits=",lengthwiseSplits[i]),
                    " - isFirstCrossSection=", isFirstCrossSection,", isLastCrossSection=",isLastCrossSection,
                    " - isFirstSplit=", isFirstSplit,", isLastSplit=",isLastSplit);
                isFirstSplit=(l==0);
                isLastSplit=(l==(len(lengthwiseSplits[i])-1)); 
                // either 0 + outer wall thickness, or offsetPosition (center of wall) + 1/2 (inner) wall thickness
                widthwiseOffset=(lengthwiseSplits[i][l] + ((isFirstSplit) ? wallThickness : wallThickness/2));
                // outer segments reduce by 1/2 wall thickness
                // inner segments reduce by 2 * 1/2 wall thicknesses (i.e. 1 whole)
                widthwiseWallReduction = (isFirstSplit && isLastSplit) ? 
                        wallThickness * 2 : // no splits, both outer walls
                        (isFirstSplit || isLastSplit) ? 
                            wallThickness + wallThickness / 2 : // one outer side wall and 1/2 inner split wall
                            wallThickness; // 1/2 inner split wall, twice
                widthwiseExtra = extraAmount(isFirstSplit, isLastSplit, startingInternalTopWidthwiseExtra,
                        endingInternalTopWidthwiseExtra);
                // widthwiseExtra = (isFirstSplit) ? startingInternalTopWidthwiseExtra :
                //     (isLastSplit) ? endingInternalTopWidthwiseExtra : 0;

                cutoutBl = ((isLastCrossSection) ? bottomLength : crosswaysDividerOffsets[i+1]) -
                        crosswaysDividerOffsets[i] - lengthwiseWallReduction;
                cutoutBw = ((isLastSplit) ? bottomWidth : lengthwiseSplits[i][l+1]) - 
                        lengthwiseSplits[i][l] - widthwiseWallReduction;

                cutoutTl = cutoutBl + lengthwiseExtra;
                cutoutTw = cutoutBw + widthwiseExtra;

                cutoutFlipLengthwise = isFirstCrossSection;
                isFullWidthAndNotCentered = (isFirstSplit && isLastSplit) && !centerWidthwise;
                // Do not flip when no inner splits and not centered
                cutoutFlipWidthwise = isFirstSplit && !isFullWidthAndNotCentered;
                centerSplitsWidthwise=(centerWidthwise && (isFirstSplit && isLastSplit)); // otherwise false
                clipBottomHeight=((allFullDepth || pocketDepths[i][l] < 0) ? 0 : wallHeight-pocketDepths[i][l]);
                translate([widthwiseOffset,lengthwiseOffset,bottomThickness])
                    taperedBox(bl=cutoutBl, bw=cutoutBw, tl=cutoutTl, tw=cutoutTw,
                        ht=wallHeight+overlap,
                        centerWidthwise=centerSplitsWidthwise, centerLengthwise=false,
                        flipLengthwise=cutoutFlipLengthwise,
                        flipWidthwise=cutoutFlipWidthwise,
                        clipBottomHeight=clipBottomHeight
                        );
            }
        } 
    }
}

function extraAmount(isFirst, isLast, startingExtraAmount, endingExtraAmount) = 
    (isFirst && isLast) ? (startingExtraAmount + endingExtraAmount) : // all of it
        extraAmountPart(isFirst, isLast, startingExtraAmount, endingExtraAmount); // just one part
function extraAmountPart(isFirst, isLast, startingExtraAmount, endingExtraAmount) =
    (isFirst) ? startingExtraAmount : ((isLast) ? endingExtraAmount : 0);

/*
 * Alternative way to specify each row of dividers with array of
 *  [ height, [[width,pocketDepth], [width,pocketDepth], [width,pocketDepth]] ],
 *  [ height, [[width,pocketDepth], [width,pocketDepth]] ],
 *  ...
 */
* translate([75,0,0])
    caddyOrganizerDividerAlt(); // test defaults
module caddyOrganizerDividerAlt(bottomThickness=2, wallThickness=1, 
        bottomWidth=50, topWidth=55,
        bottomLength=75, topLength=80,
        wallHeight=25,
        dividerSpec=[
            [0,[[0,10],[25,0]]],
            [30, [[0,15],[20,0],[30,0]]]
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

