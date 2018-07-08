# Flutter_MaterialSheetAndNavigationDrawer MASSIVE CHANGES NOT YET EXPLAINED, DOCUMENT NOT UPDATED

<h3>Purpose</h3>

A Very Flexible Widget that can Implement Material Sheets (bottom, top, side) (modal and persistent) 

<h3>Features</h3>

MULTIPLE SHEETS PER APP

WIDGET PARAMETERS
1. app [required] -> the application that goes behind the sheet
2. sheet [required] -> the sheet that animates in or out of the screen
3. attachment -> an attachment to the sheet that is always on screen

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
10. maxAnimationTimeInMilliseconds -> how long the sheet takes to open or close if animated
11. indicatorAutoCloseColor -> the color that shows up when the sheet will auto close if let go [opacity matter]
12. scrimOpenColor -> the color of the scrim when using a modal sheet [opacity matters]
13. sheetMin -> the smallest the sheet can be
14. sheetMax -> the largest the sheet can be
15. textDirection -> the text direction inside of the sheet

FUNCTIONS TO GRAB INFORMATION
1. getOpenPercent() -> get how open the sheet is [0.0 -> 1.0]
2. getAttachmentSize() -> get the width and height of the attachment
3. getSheetSize() -> get the width and height of the sheet

FUNCTIONS TO RUN COMMANDS
1. toggleInstantaneous() -> toggle between opened and closed states with no animation
2. toggleAnimated() -> toggle between opened and closed states with animation 
3. openInstantaneous() -> open the sheet instantly
4. openAnimated() -> open the sheet with an animation
5. closeInstantaneous() -> close the sheet instantly
6. closeAnimated() -> close the sheet with an animation

<h3>Limitation</h3>
I was not created to be performant.
Modify my code if needed to suit your specific needs and get the best performance possible.

<h3>How To</h3>

```
import 'package:flutter/material.dart';
import 'materialSheet.dart';

void main() => runApp(new MaterialSheetTestApp());

class MaterialSheetTestApp extends StatelessWidget {

  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  Sheet matSheet;
  getOpenPercent() => matSheet.functions.getOpenPercent();
  getSheetSize() => matSheet.functions.getSheetSize();
  getAttachmentSize() => matSheet.functions.getAttachmentSize();
  toggleInstant() => matSheet.functions.toggleInstantaneous();
  toggleAnim() => matSheet.functions.toggleAnimated();
  openInstant() => matSheet.functions.openInstantaneous();
  closeInstant() => matSheet.functions.closeInstantaneous();
  openAnim() => matSheet.functions.openAnimated();
  closeAnim() => matSheet.functions.closeAnimated();

  @override
  Widget build(BuildContext context) {
    matSheet = new Sheet(
      parameters: new Parameters(
        //-----Widgets
        app: new Container(
          child: new Center(
            child: new FlatButton(
              color: Colors.redAccent,
              onPressed: () => openAnim(),
              child: new Text("Press me to open the sheet"),
            ),
          ),
        ),
        sheet: new Container(
          color: Colors.yellowAccent,
          child: new Center(
            child: new Text(
              "Right Sheet",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        attachment: new Container(
          color: Colors.greenAccent,
          child: new Icon(
            Icons.attachment,
            color: Colors.white,
          ),
        ),
        //-----Other Vars
        position: sheetPosition.right,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
      ),
    );

    return matSheet;
  }
}
```

<h3>Plans</h3>

1. lockSheet (opened, closed, false) [mutable]
2. sheetAffectsApp (resize, move, none) [mutable]

<h3>Demos</h3>

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
<img src="https://media.giphy.com/media/35KhYdJ9CQAN6hzYbQ/giphy.gif" width="360"/>
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
<br>
<h5>With Multiple Sheets</h5>
<br>
<img src="https://media.giphy.com/media/9rsWxrJaYOhCQbRDXD/giphy.gif" width="360"/>

