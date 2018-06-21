# Flutter_MaterialSheetAndNavigationDrawer
A Very Flexible Widget that can Implement 
1. Material Sheets in all Directions (both modal and persistent) 
2. and consequently Material Navigation Drawers [which are basically sheets with some small modifications]

This Widget was created specifically because the Flutter Widget for these actions where 
1. hard to understand (for noob me) 
2. and I was not able to do what I wanted with them or edit them.

WIDGET PARAMETERS
1. app [required] -> the application that goes behind the sheet
2. sheet [required] -> the sheet that animates in or out of the screen
3. attachment -> an attachment to the sheet that is displayed on screen even if the sheet is closed so that you can drag the sheet into the screen

EXPOSED OPTIONS
1. startOpen -> whether or not the sheet should startOpen
2. position -> what edge the sheet is attached to (top, right, bottom, left)
3. type -> what type of sheet this is (modal, persistent)
4. backBtnClosesSheet -> whether or not the backButtonCloses the sheet
5. autoOpenOrCloseIndicator -> whether or not you should be shown what automatic action will play after your detected swipe gesture
6. swipeToOpen -> whether or not you can swipe the sheet to open (if no attachment is specified you will still be able to swip in from the screen)
7. swipeToClose -> whether or not you can swipe the sheet to close
8. sheetMin -> what is the smallest the sheet can be
9. sheetMax -> what is the largest the sheet can be

HIDDEN OPTIONS (by editing materialSheet.dart file)
1. scrim color
2. autoOpenOrCloseIndicatorColor
3. Auto Animation Speed
4. and more!
