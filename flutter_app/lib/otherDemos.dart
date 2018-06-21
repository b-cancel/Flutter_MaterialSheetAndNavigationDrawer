import 'package:flutter/material.dart';
import 'materialSheet.dart';

class MaterialSheetTestApp extends StatelessWidget {
  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  //-------------------------Build Function

  @override
  Widget build(BuildContext context) {
    matSheet = new MaterialSheet(
      //-----Widgets
      app: new Container(
        color: Colors.black,
        child: new Center(
          child: new Container(
            color: Colors.purple,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  color: Colors.red,
                  child: new FlatButton(
                    onPressed: () => closeAnim(),
                    child: new Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Container(
                  color: Colors.blue,
                  child: new FlatButton(
                    onPressed: () => openInstant(),
                    child: new Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      sheet: new Container(
        color: Colors.yellowAccent,
        child: new Center(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  color: Colors.red,
                  child: new FlatButton(
                    onPressed: () => closeAnim(),
                    child: new Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Container(
                  color: Colors.blue,
                  child: new FlatButton(
                    onPressed: () => openInstant(),
                    child: new Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
      startOpen: true,
      position: sheetPosition.right,
      sheetMin: 250.0,
      autoOpenOrCloseIndicator: true,
      type: sheetType.persistent,
      placement: attachmentPlacement.inside,
    );

    return matSheet;
  }
}