import 'package:flutter/material.dart';
import 'package:material_sheets/materialSheet.dart';

class MaterialSheetTestApp extends StatelessWidget {
  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  Sheet matSheet;
  toggleInstant() => matSheet.functions.toggleInstantaneous();
  toggleAnim() => matSheet.functions.toggleAnimated();
  openInstant() => matSheet.functions.openInstantaneous();
  closeInstant() => matSheet.functions.closeInstantaneous();
  openAnim() => matSheet.functions.openAnimated();
  closeAnim() => matSheet.functions.closeAnimated();

  //-------------------------Build Function

  @override
  Widget build(BuildContext context) {
    matSheet = new Sheet(
      parameters: new Parameters(
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
  toggleInstantR() => rightSheet.functions.toggleInstantaneous();
  toggleAnimR() => rightSheet.functions.toggleAnimated();
  openInstantR() => rightSheet.functions.openInstantaneous();
  closeInstantR() => rightSheet.functions.closeInstantaneous();
  openAnimR() => rightSheet.functions.openAnimated();
  closeAnimR() => rightSheet.functions.closeAnimated();

  Sheet leftSheet;
  toggleInstantL() => leftSheet.functions.toggleInstantaneous();
  toggleAnimL() => leftSheet.functions.toggleAnimated();
  openInstantL() => leftSheet.functions.openInstantaneous();
  closeInstantL() => leftSheet.functions.closeInstantaneous();
  openAnimL() => leftSheet.functions.openAnimated();
  closeAnimL() => leftSheet.functions.closeAnimated();

  Sheet bottomSheet;
  toggleInstantB() => bottomSheet.functions.toggleInstantaneous();
  toggleAnimB() => bottomSheet.functions.toggleAnimated();
  openInstantB() => bottomSheet.functions.openInstantaneous();
  closeInstantB() => bottomSheet.functions.closeInstantaneous();
  openAnimB() => bottomSheet.functions.openAnimated();
  closeAnimB() => bottomSheet.functions.closeAnimated();

  Sheet topSheet;
  toggleInstantT() => topSheet.functions.toggleInstantaneous();
  toggleAnimT() => topSheet.functions.toggleAnimated();
  openInstantT() => topSheet.functions.openInstantaneous();
  closeInstantT() => topSheet.functions.closeInstantaneous();
  openAnimT() => topSheet.functions.openAnimated();
  closeAnimT() => topSheet.functions.closeAnimated();

  //-------------------------Build Function

  @override
  Widget build(BuildContext context) {
    rightSheet = new Sheet(
      parameters: new Parameters(
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
        type: sheetType.persistent,
      ),
    );

    leftSheet = new Sheet(
      parameters: new Parameters(
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
          color: Colors.orangeAccent,
          child: new Icon(
            Icons.attachment,
            color: Colors.white,
          ),
        ),
        //-----Other Vars
        position: sheetPosition.left,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
        type: sheetType.persistent,
      ),
    );

    topSheet = new Sheet(
      parameters: new Parameters(
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
          child: new Column(
            children: <Widget>[
              new Icon(
                Icons.attachment,
                color: Colors.white,
              ),
              new Icon(
                Icons.attachment,
                color: Colors.white,
              ),
            ],
          )
        ),
        //-----Other Vars
        position: sheetPosition.top,
        autoOpenOrCloseIndicator: true,
        placement: attachmentPlacement.inside,
        type: sheetType.persistent,
      ),
    );

    bottomSheet = new Sheet(
      parameters: new Parameters(
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
        type: sheetType.persistent,
      ),
    );

    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.blue,
          child: new Center(
            child: new Text(
              "SOME APP",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        rightSheet,
        leftSheet,
        bottomSheet,
        topSheet,
      ],
    );
  }
}