import 'package:flutter/material.dart';
import 'package:material_sheets/materialSheet.dart';

//-------------------------Persistent Bottom Sheet-------------------------

class PersistentBottomSheet extends StatefulWidget {
  @override
  _PersistentBottomSheetState createState() => _PersistentBottomSheetState();
}

class _PersistentBottomSheetState extends State<PersistentBottomSheet> {
  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  void _showMessage() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: const Text('You tapped the floating action button.'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    matSheet = new MaterialSheet(
      app: new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(_backIcon()),
              alignment: Alignment.centerLeft,
              tooltip: 'Back',
              onPressed: () => print("there is nothing to Pop"),
            ),
            title: const Text('Persistent bottom sheet'),
          ),
          body: new Center(
            child: new RaisedButton(
              onPressed: openAnim,
              child: const Text('SHOW BOTTOM SHEET'),
            ),
          ),
        ),
      ),
      sheet: new Material(
        child: new Container(
          decoration: new BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            border: new Border(
              top: new BorderSide(
                  color: themeData.disabledColor
              ),
            ),
          ),
          child: new Padding(
            padding: const EdgeInsets.all(32.0),
            child: new Text(
              'This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
              textAlign: TextAlign.center,
              style: new TextStyle(color: themeData.accentColor, fontSize: 24.0, ),
            ),
          ),
        ),
      ),
      attachment: new Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.all(16.0),
        child: new FloatingActionButton(
          onPressed: _showMessage,
          backgroundColor: Colors.redAccent,
          child: const Icon(
            Icons.add,
            semanticLabel: 'Add',
          ),
        ),
      ),
      type: sheetType.persistent,
      swipeToOpen: false,
    );

    return matSheet;
  }
}

//-------------------------Modal Bottom Sheet-------------------------

class ModalBottomSheet extends StatelessWidget {

  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  IconData _backIcon(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {

    matSheet = new MaterialSheet(
      app: new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(_backIcon(context)),
              alignment: Alignment.centerLeft,
              tooltip: 'Back',
              onPressed: () => print("there is nothing to Pop"),
            ),
            title: const Text('Modal bottom sheet'),
          ),
          body: new Center(
            child: new RaisedButton(
              child: const Text('SHOW BOTTOM SHEET'),
              onPressed: openAnim,
            ),
          ),
        ),
      ),
      sheet: new Material(
        child: new Container(
          child: new Padding(
            padding: const EdgeInsets.all(32.0),
            child: new Text(
              'This is the modal bottom sheet. Click anywhere to dismiss.',
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Theme
                      .of(context)
                      .accentColor,
                  fontSize: 24.0
              ),
            ),
          ),
        ),
      ),
      type: sheetType.modal,
      swipeToOpen: false,
    );

    return matSheet;
  }
}

//-------------------------Navigation Drawer-------------------------

const String _kAsset0 = 'people/square/trevor.png';
const String _kAsset1 = 'people/square/stella.png';
const String _kAsset2 = 'people/square/sandra.png';
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => new _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>{

  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static const List<String> _drawerContents = const <String>['A', 'B', 'C', 'D', 'E'];

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
        content: const Text("The drawer's items don't do anything")
    ));
  }

  void _onOtherAccountsTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('Account switching not implemented.'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    matSheet = new MaterialSheet(
        app: new MaterialApp(
          home: new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: new IconButton(
                icon: new Icon(_backIcon()),
                alignment: Alignment.centerLeft,
                tooltip: 'Back',
                onPressed: () => print("there is nothing to Pop"),
              ),
              title: const Text('Navigation drawer'),
            ),
            body: new Center(
              child: new InkWell(
                onTap: openAnim,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: const AssetImage(
                            _kAsset0,
                            package: _kGalleryAssetsPackage,
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: new Text('Tap here to open the drawer',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        sheet: new Column(
          children: <Widget>[
            /*
            new UserAccountsDrawerHeader(
              accountName: const Text('Trevor Widget'),
              accountEmail: const Text('trevor.widget@example.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                backgroundImage: const AssetImage(
                  _kAsset0,
                  package: _kGalleryAssetsPackage,
                ),
              ),

              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  onTap: () {
                    _onOtherAccountsTap(context);
                  },
                  child: new Semantics(
                    label: 'Switch to Account B',
                    child: const CircleAvatar(
                      backgroundImage: const AssetImage(
                        _kAsset1,
                        package: _kGalleryAssetsPackage,
                      ),
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    _onOtherAccountsTap(context);
                  },
                  child: new Semantics(
                    label: 'Switch to Account C',
                    child: const CircleAvatar(
                      backgroundImage: const AssetImage(
                        _kAsset2,
                        package: _kGalleryAssetsPackage,
                      ),
                    ),
                  ),
                ),
              ],

              margin: EdgeInsets.zero,
              onDetailsPressed: () {//TODO... controller forward or reverse
              },
            ),
            */
            /*
            new Expanded(
              child: new ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[

                    new Stack(
                      children: <Widget>[
                        // The initial contents of the drawer.
                        new FadeTransition(
                          opacity: _drawerContentsOpacity,
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _drawerContents.map((String id) {
                              return new ListTile(
                                leading: new CircleAvatar(child: new Text(id)),
                                title: new Text('Drawer item $id'),
                                onTap: _showNotImplementedMessage,
                              );
                            }).toList(),
                          ),
                        ),
                        // The drawer's "details" view.
                        new SlideTransition(
                          position: _drawerDetailsPosition,
                          child: new FadeTransition(
                            opacity: new ReverseAnimation(_drawerContentsOpacity),
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new ListTile(
                                  leading: const Icon(Icons.add),
                                  title: const Text('Add account'),
                                  onTap: _showNotImplementedMessage,
                                ),
                                new ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('Manage accounts'),
                                  onTap: _showNotImplementedMessage,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                ],
              ),
            ),
            */
          ],
        ),
      position: sheetPosition.left,
    );

    return matSheet;
  }
}

//-------------------------Bottom Sheet From List Demo-------------------------

enum _MaterialListType {oneLine, oneLineWithAvatar, twoLine, threeLine}

class ListDemo extends StatefulWidget {
  const ListDemo({ Key key }) : super(key: key);

  @override
  _ListDemoState createState() => new _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {

  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _MaterialListType _itemType = _MaterialListType.threeLine;
  bool _dense = false;
  bool _showAvatars = true;
  bool _showIcons = false;
  bool _showDividers = false;
  bool _reverseSort = false;
  List<String> items = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  //-------------------------Helper Functions
  //NOTE: these are required if you want buttons that will be opening or closing the sheet

  MaterialSheet matSheet;
  toggleInstant() => matSheet.toggleInstantaneous();
  toggleAnim() => matSheet.toggleAnimated();
  openInstant() => matSheet.openInstantaneous();
  closeInstant() => matSheet.closeInstantaneous();
  openAnim() => matSheet.openAnimated();
  closeAnim() => matSheet.closeAnimated();

  bool testBool = true;

  @override
  Widget build(BuildContext context){
    const scaffColor = Color(0xfffafafa); //manually read in from Theme.of(context).scaffoldBackgroundColor

    final String layoutText = _dense ? ' \u2013 Dense' : '';
    String itemTypeText;
    switch (_itemType) {
      case _MaterialListType.oneLine:
      case _MaterialListType.oneLineWithAvatar:
        itemTypeText = 'Single-line';
        break;
      case _MaterialListType.twoLine:
        itemTypeText = 'Two-line';
        break;
      case _MaterialListType.threeLine:
        itemTypeText = 'Three-line';
        break;
    }

    Iterable<Widget> listTiles = items.map((String item) => buildListTile(context, item));
    if (_showDividers)
      listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    matSheet = new MaterialSheet(
        app: new MaterialApp(
          home: new Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              leading: new IconButton(
                icon: new Icon(_backIcon()),
                alignment: Alignment.centerLeft,
                tooltip: 'Back',
                onPressed: () => print("there is nothing to Pop"),
              ),
              title: new Text('Scrolling list\n$itemTypeText$layoutText'),
              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.sort_by_alpha),
                  tooltip: 'Sort',
                  onPressed: () {
                    setState(() {
                      _reverseSort = !_reverseSort;
                      items.sort((String a, String b) => _reverseSort ? b.compareTo(a) : a.compareTo(b));
                    });
                  },
                ),
                new IconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Show menu',
                  onPressed: toggleAnim,
                ),
              ],
            ),
            body: new Scrollbar(
              child: new ListView(
                padding: new EdgeInsets.symmetric(vertical: _dense ? 4.0 : 8.0),
                children: listTiles.toList(),
              ),
            ),
          ),
        ),
        sheet: new Container(
          decoration: const BoxDecoration(
            border: const Border(top: const BorderSide(color: Colors.black26)),
            color: scaffColor,
          ),
          child: new ListView(
            shrinkWrap: true,
            primary: false, //NOTE: if this is commented out behavior of scrolling will supercede that of closing the sheet
            children: <Widget>[
              new MergeSemantics(
                child: new ListTile(
                    dense: true,
                    title: const Text('One-line'),
                    trailing: new Radio<_MaterialListType>(
                      value: _showAvatars ? _MaterialListType.oneLineWithAvatar : _MaterialListType.oneLine,
                      groupValue: _itemType,
                      onChanged: changeItemType,
                    )
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                    dense: true,
                    title: const Text('Two-line'),
                    trailing: new Radio<_MaterialListType>(
                      value: _MaterialListType.twoLine,
                      groupValue: _itemType,
                      onChanged: changeItemType,
                    )
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                  dense: true,
                  title: const Text('Three-line'),
                  trailing: new Radio<_MaterialListType>(
                    value: _MaterialListType.threeLine,
                    groupValue: _itemType,
                    onChanged: changeItemType,
                  ),
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                  dense: true,
                  title: const Text('Show avatar'),
                  trailing: new Checkbox(
                    value: _showAvatars,
                    onChanged: (bool value) {
                      setState(() {
                        _showAvatars = value;
                      });
                    },
                  ),
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                  dense: true,
                  title: const Text('Show icon'),
                  trailing: new Checkbox(
                    value: _showIcons,
                    onChanged: (bool value) {
                      setState(() {
                        _showIcons = value;
                      });
                    },
                  ),
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                  dense: true,
                  title: const Text('Show dividers'),
                  trailing: new Checkbox(
                    value: _showDividers,
                    onChanged: (bool value) {
                      setState(() {
                        _showDividers = value;
                      });
                    },
                  ),
                ),
              ),
              new MergeSemantics(
                child: new ListTile(
                  dense: true,
                  title: const Text('Dense layout'),
                  trailing: new Checkbox(
                    value: _dense,
                    onChanged: (bool value) {
                      setState(() {
                        _dense = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      type: sheetType.persistent,
      swipeToOpen: false,
    );

    return  new Material(child: matSheet);
  }

  //--------------------------------------------------


  void changeItemType(_MaterialListType type) {
    setState(() {
      _itemType = type;
    });
  }

  Widget buildListTile(BuildContext context, String item) {
    Widget secondary;
    if (_itemType == _MaterialListType.twoLine) {
      secondary = const Text('Additional item information.');
    } else if (_itemType == _MaterialListType.threeLine) {
      secondary = const Text(
        'Even more additional list item information appears on line three.',
      );
    }
    return new MergeSemantics(
      child: new ListTile(
        isThreeLine: _itemType == _MaterialListType.threeLine,
        dense: _dense,
        leading: _showAvatars ? new ExcludeSemantics(child: new CircleAvatar(child: new Text(item))) : null,
        title: new Text('This item represents $item.'),
        subtitle: secondary,
        trailing: _showIcons ? new Icon(Icons.info, color: Theme.of(context).disabledColor) : null,
      ),
    );
  }
}
