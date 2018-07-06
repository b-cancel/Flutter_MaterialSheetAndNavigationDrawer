# Flutter_MaterialSheetAndNavigationDrawer

<h3>What Am I</h3>

A Very Flexible Widget that can Implement...
1. Material Sheets (bottom, top, side) (modal and persistent) 
2. Material Navigation Drawers

<h3>Why Do I Exist</h3>

This Widget was created specifically because I wanted to...
1. challenge myself
2. use Side Material Sheets (Material.io mentions they are not currently implemented)
3. learn to override the back button
4. have more options when constructing my applications

<h3>What You Need To Use Me</h3>

WIDGET PARAMETERS
1. app [required] -> the application that goes behind the sheet
2. sheet [required] -> the sheet that animates in or out of the screen
3. attachment -> an attachment to the sheet that is always on screen

<h3>What Benefits I Provide</h3>

VARIABLE PARAMETERS
1. startOpen -> whether or not the sheet should startOpen (true, false)
2. position -> what edge the sheet is attached to (top, right, bottom, left)
3. type -> what type of sheet this is (modal, persistent)
4. placement -> where the attachment is placed relative to the screen edges (inside, outside)
5. backBtnClosesSheet -> whether or not the back button closes the sheet
6. backBtnClosesAnimated -> whether the back button closes the sheet animated or instantaneously
7. autoOpenOrCloseIndicator -> whether or not you should be shown whether you sheet will autoClose or autoOpen after you let go of it
8. swipeToOpen -> whether or not you can swipe the sheet to open (NOTE: if no attachment is specified you will swipe the edge of the screen to open)
9. swipeToClose -> whether or not you can swipe the sheet to close
10. animationSpeedInMilliseconds -> how long the sheet takes to open or close if animated
11. indicatorAutoCloseColor -> the color that shows up when the sheet will auto close if let go [opacity matter]
12. scrimOpenColor -> the color of the scrim when using a modal sheet [opacity matters]
13. sheetMin -> the smallest the sheet can be
14. sheetMax -> the largest the sheet can be

OTHER VARIABLES (easily edited by modifying materialSheet.dart file)
1. scrim color
2. autoOpenOrCloseIndicatorColor
3. Auto Animation Speed
4. and more!

FUNCTIONS
1. toggleInstant() -> toggle between opened and closed states with no animation
2. toggleAnim() -> toggle between opened and closed states with animation 
3. openInstant() -> open the sheet instantly
4. openAnim() -> open the sheet with an animation
5. closeInstant() -> close the sheet instantly
6. closeAnim() -> close the sheet with an animation

<h3>My Limitations</h3>
I was not Created To Have The Best Performance.
Given the large quantity of options it might be best to modify the code to only include the options you need.

<h3>How To Use Me</h3>

```
import 'package:flutter/material.dart';
import 'materialSheet.dart';

class MaterialSheetTestApp extends StatelessWidget {

  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  @override
  Widget build(BuildContext context) {
    matSheet = new MaterialSheet(
      /*
      * Specify all the desired widgets and variables here
      * app, and sheet are required
      * If you require one of the available functions inside of the Material Sheet simply call them from here
      * For Examples inspect the "demo" dart files, and view the result of each by commenting all but one "runApp"
      */
    );

    return matSheet;
  }
}
```

<h3>Future Plans</h3>
-getOpenPercent Function
-getAttachmentSize, getSheetSize Functions
-multiple sheets on screen (currently a strange bug is stopping this)
-animationSpeedInMilliseconds is the ammount of time a sheet takes to full open, not just to complete opening [immutable]
-lockSheet (opened, closed, false) [mutable]
-sheetAffectsApp (resize, move, none) [mutable]

<h3>Demonstrations Of My Abilities</h3>

Remember to comment out every "runApp" in main.dart except the one you want to view

<h5>Persistent Bottom Sheet</h5>
<br>
<img src="https://media.giphy.com/media/dYng1K8blxvnsLhP81/giphy.gif" width="360"/>
<br>
<h5>Modal Bottom Sheet</h5>
<br>
<img src="https://media.giphy.com/media/dkXLQACALhF6puhk3I/giphy.gif" width="360"/>
<br>
<h5>List Demo with Persistent Bottom Sheet With Options</h5>
<br>
<img src="https://media.giphy.com/media/3fih4lYknMevFgu4O2/giphy.gif" width="360"/>
<br>
<h5>Navigation Drawer (comming soon)</h5>
<br>
<img src="https://media.giphy.com/media/5e3CNDPwoWESMRgGtw/giphy.gif" width="360"/>
<br>
<h5>Attachment Inside</h5>
<br>
<img src="https://media.giphy.com/media/QmDaRdVzd3hjjeyIwB/giphy.gif" width="360"/>
<br>
<h5>Attachment Outside</h5>
<br>
<img src="https://media.giphy.com/media/20OQm9fCzezqHSHpgM/giphy.gif" width="360"/>

