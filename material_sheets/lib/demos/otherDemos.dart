import 'package:flutter/material.dart';
import 'package:material_sheets/materialSheet.dart';

class MaterialSheetTestApp extends StatelessWidget {
  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  Sheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  //-------------------------Build Function

  @override
  Widget build(BuildContext context) {
    matSheet = new Sheet(
      params: new Parameters(
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
      ),
    );

    return matSheet;
  }
}

class MultiSheets extends StatelessWidget {
  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  Sheet rightSheet;
  toggleInstantR() => rightSheet.toggleInstantaneous();
  toggleAnimR() => rightSheet.toggleAnimated();
  openInstantR() => rightSheet.openInstantaneous();
  closeInstantR() => rightSheet.closeInstantaneous();
  openAnimR() => rightSheet.openAnimated();
  closeAnimR() => rightSheet.closeAnimated();

  Sheet leftSheet;
  toggleInstantL() => leftSheet.toggleInstantaneous();
  toggleAnimL() => leftSheet.toggleAnimated();
  openInstantL() => leftSheet.openInstantaneous();
  closeInstantL() => leftSheet.closeInstantaneous();
  openAnimL() => leftSheet.openAnimated();
  closeAnimL() => leftSheet.closeAnimated();

  Sheet bottomSheet;
  toggleInstantB() => bottomSheet.toggleInstantaneous();
  toggleAnimB() => bottomSheet.toggleAnimated();
  openInstantB() => bottomSheet.openInstantaneous();
  closeInstantB() => bottomSheet.closeInstantaneous();
  openAnimB() => bottomSheet.openAnimated();
  closeAnimB() => bottomSheet.closeAnimated();

  Sheet topSheet;
  toggleInstantT() => topSheet.toggleInstantaneous();
  toggleAnimT() => topSheet.toggleAnimated();
  openInstantT() => topSheet.openInstantaneous();
  closeInstantT() => topSheet.closeInstantaneous();
  openAnimT() => topSheet.openAnimated();
  closeAnimT() => topSheet.closeAnimated();

  //-------------------------Build Function

  @override
  Widget build(BuildContext context) {
    rightSheet = new Sheet(
      params: new Parameters(
        //-----Widgets
        app: new Container(),
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

    leftSheet = new Sheet(
      params: new Parameters(
        //-----Widgets
        app: Container(),
        sheet: new Container(
          color: Colors.yellowAccent,
          child: new Center(
            child: new Text(
              "Left Sheet",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        attachment: new Container(
          color: Colors.pinkAccent,
          child: new Icon(
            Icons.attachment,
            color: Colors.white,
          ),
        ),
        //-----Other Vars
        position: sheetPosition.left,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
      ),
    );

    topSheet = new Sheet(
      params: new Parameters(
        //-----Widgets
        app: Container(),
        sheet: new Container(
          color: Colors.purple,
          child: new Center(
            child: new Text(
              "Top Sheet",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        attachment: new Container(
          color: Colors.pinkAccent,
          child: new Icon(
            Icons.attachment,
            color: Colors.white,
          ),
        ),
        //-----Other Vars
        position: sheetPosition.top,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
      ),
    );

    bottomSheet = new Sheet(
      params: new Parameters(
        //-----Widgets
        app: Container(),
        sheet: new Container(
          color: Colors.yellowAccent,
          child: new Center(
            child: new Text(
              "Bottom Sheet",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        attachment: new Container(
          color: Colors.redAccent,
          child: new Icon(
            Icons.attachment,
            color: Colors.white,
          ),
        ),
        //-----Other Vars
        position: sheetPosition.bottom,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
      ),
    );

    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.blue,
          child: new Center(
            child: new Text(
              "MAIN",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        rightSheet,
        //leftSheet,
        //bottomSheet,
        //topSheet,
      ],
    );
  }
}