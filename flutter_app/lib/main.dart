import 'package:flutter/material.dart';
import 'materialSheet.dart';

void main() => runApp(new MaterialSheetApp());

class MaterialSheetApp extends StatelessWidget {

  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  openSheet() => matSheet.openSheet();
  closeSheet() => matSheet.closeSheet();

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
                      onPressed: () => closeSheet(),
                      child: new Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  new Container(
                    color: Colors.blue,
                    child: new FlatButton(
                      onPressed: () => openSheet(),
                      child: new Icon(
                        Icons.open_in_browser,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      sheet: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              color: Colors.red,
              child: new FlatButton(
                onPressed: () => closeSheet(),
                child: new Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            new Container(
              color: Colors.blue,
              child: new FlatButton(
                onPressed: () => openSheet(),
                child: new Icon(
                  Icons.open_in_browser,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      attachment: new Icon(
        Icons.attachment,
        color: Colors.white,
      ),
      //-----Other Vars
      startOpen: true,
      position: sheetPosition.right,
      placement: attachmentPlacement.inside,
      type: sheetType.modal,
      sheetMin: 150.0,
    );

    return matSheet;
  }
}