# Flutter_MaterialSheetAndNavigationDrawer

<h3>What Am I<h3>

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
6. autoOpenOrCloseIndicator -> whether or not you should be shown whether you sheet will autoClose or autoOpen after you let go of it
7. swipeToOpen -> whether or not you can swipe the sheet to open (NOTE: if no attachment is specified you will swipe the edge of the screen to open)
8. swipeToClose -> whether or not you can swipe the sheet to close
9. sheetMin -> the smallest the sheet can be
10. sheetMax -> the largest the sheet can be

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

<h3>How To Use Me</h3>

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

<h3>Demonstrations Of My Abilities</h3>

Remember to comment out every "runApp" in main.dart except the one you want to view


