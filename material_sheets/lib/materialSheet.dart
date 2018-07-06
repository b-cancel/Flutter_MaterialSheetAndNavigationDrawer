import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

//TODO... refactor

//TODO... convert to class of functions that can be accessible from anywhere

//-------------------------Enumerations-------------------------

enum sheetPosition { top, right, bottom, left }
enum sheetType { modal, persistent }
enum attachmentPlacement { inside, outside }

//-------------------------Global Variables (different for each instance)-------------------------

class GlobalFunctions{
  Function getAnimationTicker;
  Function setAnimationTicker;

  Function getAnimationOpenOrClose;
  Function setAnimationOpenOrClose;

  Function getSlideUpdateStream;
  Function setSlideUpdateStream;

  Function getOpenPercent;
  Function setOpenPercent;
}

//-------------------------Material Sheet-------------------------

//NOTE: this has to be stateless so that I can address the sheetOpen and sheetClose Functions
class MaterialSheet extends StatelessWidget{

  //-------------------------Parameters

  MaterialSheet(
      {Key key,
        @required this.app,
        @required this.sheet,
        this.attachment,

        this.startOpen: false,
        this.position: sheetPosition.bottom,
        this.type: sheetType.modal,
        this.placement: attachmentPlacement.inside,
        this.backBtnClosesSheet: true,
        this.backBtnClosesAnimated: true,
        this.autoOpenOrCloseIndicator: false,

        this.swipeToOpen: true,
        this.swipeToClose: true,

        this.animationSpeedInMilliseconds: 100, //full anim should take 200, auto anim completes the anim up to 50% so 100
        this.indicatorAutoCloseColor: const Color.fromRGBO(0,0,0,.5),
        this.scrimOpenColor: const Color.fromRGBO(0,0,0,.5),

        //TODO... In Progress
        this.sheetMin,
        this.sheetMax,
      })
      : super(key: key);

  //the application that the sheet is going to appear in front of
  final Widget app;
  //the primary sheet component that shows the content that shows and hides
  final Widget sheet;
  //the secondary sheet component that always shows regardless of whether or not the sheet is open or closed
  final Widget attachment;

  //whether or not the sheet starts of open or closed
  final bool startOpen;
  //what edge the sheet is stuck to
  final sheetPosition position;
  //whether the sheet is modal or persistent
  final sheetType type;
  //whether the secondary widget is closer to the center or the screen (inside) or further away (outside)
  final attachmentPlacement placement;
  //whether or not the backButton closes the Sheet (ONLY android)
  final bool backBtnClosesSheet;
  //how the sheet closes when you press the backButton
  final bool backBtnClosesAnimated;
  //if you drag the sheet but not all the way after 50% on either side it will open or close automatically
  //this will show an indicator when the action that will be taken is obvious
  //darker overlay means it will close, no overlay means it will open
  final bool autoOpenOrCloseIndicator;

  //whether or not we can swipe from the edge of the screen or the attachment to open the sheet
  final bool swipeToOpen;
  //whether or not we can swipe the sheet to close it (gesture detector lets event pass through)
  final bool swipeToClose;

  //how long the animator will take to automatically complete the closing or opening of the sheet
  final int animationSpeedInMilliseconds;
  //the color that shows up over the sheet when the animator will automatically close the sheet if the sheet is let go
  final Color indicatorAutoCloseColor;
  //the scrim color that will be linearly interpolated to as you open or close a modal sheet
  final Color scrimOpenColor;

  //---------TODO... In Progress
  //if you have too little content you still want your sheet to be a particular size (might have to align)
  final double sheetMin;
  //if you dont want your sheet to be larger than a certain size
  final double sheetMax; //TODO... set inherent limit (max size).... allow overflow to just be scrolled

  //-------------------------"Instance Global"

  final globals = new GlobalFunctions();

  //-------------------------Helper Functions

  toggleInstantaneous(){
    if(globals.getOpenPercent() == 1.0 || globals.getOpenPercent() == 0.0)
      (globals.getOpenPercent() == 1.0) ? closeInstantaneous() : openInstantaneous();
  }
  toggleAnimated(){
    if(globals.getOpenPercent() == 1.0 || globals.getOpenPercent() == 0.0)
      (globals.getOpenPercent() == 1.0) ? closeAnimated() : openAnimated();
  }

  //-----Instantaneous
  openInstantaneous() => completeOpenOrClose(1.0, 0, globals);
  closeInstantaneous() => completeOpenOrClose(0.0, 0, globals);

  //-----Animated
  openAnimated() => completeOpenOrClose(1.0, animationSpeedInMilliseconds, globals);
  closeAnimated() => completeOpenOrClose(0.0, animationSpeedInMilliseconds, globals);

  //-------------------------Build Method

  @override
  Widget build(BuildContext context) {
    return new MediaQuery(
      data: MediaQueryData(),
      child: new Directionality(
        textDirection: TextDirection.ltr,
        child: new Stack(
          children: <Widget>[
            app,
            new SheetWidget(
              startOpen: startOpen,
              globals: globals,

              closeSheetFunc: (backBtnClosesAnimated) ? closeAnimated : closeInstantaneous,

              sheet: sheet,
              attachment: attachment,

              position: position,
              type: type,
              placement: placement,
              backBtnClosesSheet: backBtnClosesSheet,
              autoOpenOrCloseIndicator: autoOpenOrCloseIndicator,

              swipeToOpen: swipeToOpen,
              swipeToClose: swipeToClose,

              animationSpeedInMilliseconds: animationSpeedInMilliseconds,
              indicatorAutoCloseColor: indicatorAutoCloseColor,
              scrimOpenColor: scrimOpenColor,

              sheetMin: sheetMin,
              sheetMax: sheetMax, //TODO... in progress
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------The Actual Sheet-------------------------

//NOTE: this has to be stateful because with WidgetsBindingObserver requires it and setState might be called
class SheetWidget extends StatefulWidget {

  //-------------------------Parameters

  const SheetWidget({
    Key key,

    @required this.startOpen,

    @required this.globals,

    @required this.closeSheetFunc,

    @required this.sheet,
    @required this.attachment,

    @required this.position,
    @required this.type,
    @required this.placement,
    @required this.backBtnClosesSheet,
    @required this.autoOpenOrCloseIndicator,

    @required this.swipeToOpen,
    @required this.swipeToClose,

    @required this.animationSpeedInMilliseconds,
    @required this.indicatorAutoCloseColor,
    @required this.scrimOpenColor,

    //TODO... in progress
    @required this.sheetMin,
    @required this.sheetMax,
  }) : super(key: key);

  final bool startOpen;

  final GlobalFunctions globals;

  final Function closeSheetFunc;

  final Widget sheet;
  final Widget attachment;

  final sheetPosition position;
  final sheetType type;
  final attachmentPlacement placement;
  final bool backBtnClosesSheet;
  final bool autoOpenOrCloseIndicator;

  final bool swipeToOpen;
  final bool swipeToClose;

  final int animationSpeedInMilliseconds;
  final Color indicatorAutoCloseColor;
  final Color scrimOpenColor;

  //TODO... in progress
  final double sheetMin;
  final double sheetMax;

  @override
  _SheetWidgetState createState() => new _SheetWidgetState();
}

class _SheetWidgetState extends State<SheetWidget> with WidgetsBindingObserver{

  //-------------------------Parameters

  static bool startOpen;

  static GlobalFunctions globals;

  static Function closeSheetFunc;

  static Widget sheet;
  static Widget attachment;

  static sheetPosition position;
  static sheetType type;
  static attachmentPlacement placement;
  static bool backBtnClosesSheet;
  static bool autoOpenOrCloseIndicator;

  static bool swipeToOpen;
  static bool swipeToClose;

  static int animationSpeedInMilliseconds;
  static Color indicatorAutoCloseColor;
  static Color scrimOpenColor;

  //TODO... in progress
  static double sheetMin;
  static double sheetMax;

  void _tieVarsBeforeBuildRun() {
    startOpen = widget.startOpen;

    globals = widget.globals;

    closeSheetFunc = widget.closeSheetFunc;

    sheet = widget.sheet;
    attachment = widget.attachment;
    position = widget.position;
    type = widget.type;
    placement = widget.placement;
    backBtnClosesSheet = widget.backBtnClosesSheet;
    autoOpenOrCloseIndicator = widget.autoOpenOrCloseIndicator;

    swipeToOpen = widget.swipeToOpen;
    swipeToClose = widget.swipeToClose;

    animationSpeedInMilliseconds = widget.animationSpeedInMilliseconds;
    indicatorAutoCloseColor = widget.indicatorAutoCloseColor;
    scrimOpenColor = widget.scrimOpenColor;

    //TODO.... in progress
    sheetMin = widget.sheetMin;
    sheetMax = widget.sheetMax;
  }

  //-------------------------Local Variables

  var wholeKey = new GlobalKey();
  var attachKey = new GlobalKey();

  //-------------------------Required For Reading in sheetWidth and sheetHeight

  int requiredBuildsPerChange = 2;
  int timesBuilt = 0;

  rebuildAsync() async{
    await Future.delayed(Duration.zero);
    setState(() {});
  }

  //-------------------------GLOBAL VAR REPLACEMENTS

  TickerProvider animationTicker;
  OpenOrCloseAnimation animationOpenOrClose;
  var slideUpdateStream;
  var openPercent;

  TickerProvider  getAnimationTicker() => animationTicker;
  setAnimationTicker(TickerProvider newAT) => animationTicker = newAT;

  OpenOrCloseAnimation getAnimationOpenOrClose() => animationOpenOrClose;
  setAnimationOpenOrClose(OpenOrCloseAnimation newOOCA) => animationOpenOrClose = newOOCA;

  StreamController<double> getSlideUpdateStream() => slideUpdateStream;
  setSlideUpdateStream(StreamController<double> newSUS) => slideUpdateStream = newSUS;

  double getOpenPercent() => openPercent;
  setOpenPercent(double newOP) => openPercent = newOP;

  linkLocalToGlobalFunctions(){

    //print("link");

    var w = widget.globals;

    w.setOpenPercent = setOpenPercent;
    w.getOpenPercent = getOpenPercent;

    w.setSlideUpdateStream = setSlideUpdateStream;
    w.getSlideUpdateStream = getSlideUpdateStream;

    w.setAnimationTicker = setAnimationTicker;
    w.getAnimationTicker = getAnimationTicker;

    w.setAnimationOpenOrClose = setAnimationOpenOrClose;
    w.getAnimationOpenOrClose = getAnimationOpenOrClose;
  }

  asyncLink() async{
    await linkLocalToGlobalFunctions();
    _initGlobalVar();
  }

  //-------------------------Required For Gestures and Animations

  _initGlobalVar() {
    if(globals.getSlideUpdateStream() == null){
      globals.setSlideUpdateStream(new StreamController<double>());

      globals.getSlideUpdateStream().stream.listen((double newPercent){
        setState(() {
          globals.setOpenPercent(newPercent);
        });
      });
    }
  }

  //-------------------------Required For WidgetsBindingObserver

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    asyncLink();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //-------------------------Function That Triggers when you hit the back key

  @override
  didPopRoute(){
    bool override = backBtnClosesSheet && (globals.getOpenPercent() ==  1.0);
    if(override)
      closeSheetFunc();
    return new Future<bool>.value(override);
  }

  //-------------------------Helper Functions

  Matrix4 _calcSheetClosedTransform(bool isWidthMax, double width, double height){

    width = width ?? 0.0;
    height = height ?? 0.0;

    if(isWidthMax){ //mess with y
      if(position == sheetPosition.top) return Matrix4.translationValues(0.0, -height, 0.0);
      else return Matrix4.translationValues(0.0, height, 0.0);
    } else{ //mess with x
      if(position == sheetPosition.right) return Matrix4.translationValues(width, 0.0, 0.0);
      else return Matrix4.translationValues(-width, 0.0, 0.0);
    }
  }

  BoxConstraints _calcBoxConstraints(bool fullWidth) {
    if (sheetMin == null && sheetMax == null)
      return new BoxConstraints();
    else {
      if (sheetMin != null && sheetMax != null) {
        if (fullWidth) //we only care for height
          return new BoxConstraints(
            minHeight: sheetMin,
            maxHeight: sheetMax,
          );
        else //we only care for width
          return new BoxConstraints(minWidth: sheetMin, maxWidth: sheetMax);
      } else {
        if (sheetMin != null) {
          //we only have min
          if (fullWidth) //we only care for height
            return new BoxConstraints(minHeight: sheetMin);
          else //we only care for width
            return new BoxConstraints(minWidth: sheetMin);
        } else {
          //we only have max
          if (fullWidth) //we only care for h`eight
            return new BoxConstraints(maxHeight: sheetMax);
          else //we only care for width
            return new BoxConstraints(maxWidth: sheetMax);
        }
      }
    }
  }

  //ONLY relevant if position is top or bottom
  TextDirection _calcTextDirection(){
    if(position == sheetPosition.right){
      if(placement == attachmentPlacement.inside) return TextDirection.rtl;
      else return TextDirection.ltr;
    }else{
      if(placement == attachmentPlacement.inside) return TextDirection.ltr;
      else return TextDirection.rtl;
    }
  }

  //ONLY relevant if position is left or right
  VerticalDirection _calcVerticalDirection(){
    if(position == sheetPosition.top){
      if(placement == attachmentPlacement.inside) return VerticalDirection.down;
      else return VerticalDirection.up;
    }else{
      if(placement == attachmentPlacement.inside) return VerticalDirection.up;
      else return VerticalDirection.down;
    }
  }

  Matrix4 _calcTransform(bool isWidthMax, double width, double height){
    Matrix4 beginMatrix = Matrix4.translationValues(0.0,0.0,0.0);
    Matrix4 endMatrix = _calcSheetClosedTransform(isWidthMax, width, height);
    return Matrix4Tween(begin: endMatrix, end: beginMatrix).lerp(globals.getOpenPercent());
  }

  Color _calcIndicatorColor(){
    if(autoOpenOrCloseIndicator){
      if(globals.getOpenPercent() > .5) return indicatorAutoCloseColor.withOpacity(0.0);
      else return indicatorAutoCloseColor;
    }
    else return Colors.transparent;
  }

  //-------------------------Helper Widget Extracts

  Widget sheetWidget(double w, double h){
    return new Stack(
      children: <Widget>[
        new Container(
          width: (w == 0.0) ? null : w,
          height: (h == 0.0) ? null : h,
          child: sheet,
        ),
        new IgnorePointer(
          child: new Container(
            width: (w == 0.0) ? null : w,
            height: (h == 0.0) ? null : h,
            color: _calcIndicatorColor(),
          ),
        )
      ]
  );

  }

  Widget attachmentWidget(bool addKey){
    Widget currAttach = attachment;
    if(currAttach == null && swipeToOpen)
      currAttach = new Icon(Icons.attachment, color: Colors.transparent);

    return new Container(
      key: (addKey) ? attachKey : null,
      child: (currAttach != null) ? currAttach : null,
    );
  }

  Widget scrimWidget(){
    if(type == sheetType.modal){
      if(globals.getOpenPercent() != 0.0){
        return new Container(
          color: Color.lerp(Colors.transparent, scrimOpenColor, globals.getOpenPercent()),
          child: new GestureDetector(
            onTap: closeSheetFunc,
          ),
        );
      }
      else
        return new Container();
    }
    else
      return new Container();
  }

  Widget sheetAndAttachmentWidget(){

    //both of these are read in by build in the first build phase
    double wholeWidth = wholeKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.width;
    double wholeHeight = wholeKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.height;
    double attachWidth = attachKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.width;
    double attachHeight = attachKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.height;

    double sheetWidth = (wholeWidth == null)
        ? 0.0
        : (wholeWidth == attachWidth) ? wholeWidth : wholeWidth - attachWidth;
    double sheetHeight = (wholeHeight == null)
        ? 0.0
        : (wholeHeight == attachHeight) ? wholeHeight : wholeHeight - attachHeight;

    bool isWidthMax = (position == sheetPosition.bottom || position == sheetPosition.top);

    Widget thisSheetWidget = sheetWidget(sheetWidth, sheetHeight);

    Transform mainWidget = new Transform(
      transform: _calcTransform(isWidthMax, sheetWidth, sheetHeight),
      child: new Flex(
        direction: (isWidthMax)
            ? Axis.vertical
            : Axis.horizontal,
        //ONLY relevant if position is top or bottom
        textDirection: (position == sheetPosition.right)
            ? TextDirection.ltr
            : TextDirection.rtl,
        //ONLY relevant if position is left or right
        verticalDirection: (position == sheetPosition.top)
            ? VerticalDirection.up
            : VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Expanded(
            child: new Container(),
          ),
          new ConstrainedBox(
            constraints: _calcBoxConstraints(isWidthMax),
            child: new Container(
              key: wholeKey,
              color: Colors.transparent,
              child: new SwipeToOpenClose(
                linkFunction: asyncLink,
                globals: globals,
                isWidthMax: isWidthMax,
                position: position,
                sheetWidth: sheetWidth,
                sheetHeight: sheetHeight,
                swipeToOpen: swipeToOpen,
                swipeToClose: swipeToClose,
                animationSpeedInMilliseconds: animationSpeedInMilliseconds,
                child: new Flex(
                  direction: (isWidthMax)
                      ? Axis.vertical
                      : Axis.horizontal,
                  textDirection: _calcTextDirection(),
                  verticalDirection: _calcVerticalDirection(),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    thisSheetWidget,
                    attachmentWidget(true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );

    if(placement == attachmentPlacement.inside){
      return mainWidget;
    }
    else{
      return new Stack(
        children: <Widget>[
          mainWidget,
          new IgnorePointer(
            child: new Flex(
              direction: (isWidthMax)
                  ? Axis.vertical
                  : Axis.horizontal,
              //ONLY relevant if position is top or bottom
              textDirection: (position == sheetPosition.right)
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              //ONLY relevant if position is left or right
              verticalDirection: (position == sheetPosition.top)
                  ? VerticalDirection.up
                  : VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Expanded(
                  child: new Container(),
                ),
                attachmentWidget(false),
              ],
            ),
          ),
        ],
      );
    }
  }

  //-------------------------Build Method

  @override
  Widget build(BuildContext context) {

    linkLocalToGlobalFunctions();

    //used to make our variables more easily addressable
    _tieVarsBeforeBuildRun();

    if(globals.getOpenPercent() == null)
      globals.setOpenPercent((startOpen) ? 1.0 : 0.0);

    //---Required to read in sheetWidth and sheetHeight
    timesBuilt++;
    if(timesBuilt < requiredBuildsPerChange) rebuildAsync();
    else timesBuilt = 0;

    return new Stack(
      children: <Widget>[
        scrimWidget(),
        sheetAndAttachmentWidget(),
      ],
    );
  }
}

//-------------------------GestureDetector Code-------------------------

//NOTE: this has to be stateful because the SingleTickerProviderStateMixin requires it
class SwipeToOpenClose extends StatefulWidget {

  SwipeToOpenClose({
    @required this.linkFunction,

    @required this.globals,

    @required this.isWidthMax,
    @required this.position,
    @required this.sheetWidth,
    @required this.sheetHeight,

    @required this.swipeToOpen,
    @required this.swipeToClose,

    @required this.animationSpeedInMilliseconds,

    @required this.child,
  });

  final Function linkFunction;

  final GlobalFunctions globals;

  final bool isWidthMax;
  final sheetPosition position;
  final double sheetWidth;
  final double sheetHeight;

  final bool swipeToOpen;
  final bool swipeToClose;

  final int animationSpeedInMilliseconds;

  final Widget child;

  @override
  _SwipeToOpenCloseState createState() => _SwipeToOpenCloseState();
}

class _SwipeToOpenCloseState extends State<SwipeToOpenClose> with SingleTickerProviderStateMixin{

  //-------------------------Gesture Helpers

  Offset dragStart;
  double slideStart;

  onDragStart(DragStartDetails details){
    slideStart = widget.globals.getOpenPercent();
    dragStart = details.globalPosition;

    //NOTE: because our animation will complete any drag...
    //whenever we drag we will begin dragging our slideStart will be 0.0 or 1.0
    if(slideStart == 0.0 && widget.swipeToOpen == false)
      slideStart = null;
    if(slideStart == 1.0 && widget.swipeToClose == false)
      slideStart = null;
  }

  onDragUpdate(DragUpdateDetails details){

    widget.linkFunction();

    if(dragStart != null){
      final dragCurrent = details.globalPosition;
      var dragChange;
      if(widget.position == sheetPosition.left || widget.position == sheetPosition.top)
        dragChange = dragCurrent - dragStart;
      else
        dragChange = dragStart - dragCurrent;

      double slideAdded;

      if(widget.isWidthMax)
        slideAdded = (dragChange.dy / widget.sheetHeight);
      else
        slideAdded = (dragChange.dx / widget.sheetWidth);

      widget.globals.getSlideUpdateStream().add((slideStart + slideAdded).clamp(0.0, 1.0));
    }
  }

  onDragEnd(DragEndDetails details){
    dragStart = null;
    completeOpenOrClose((widget.globals.getOpenPercent() > 0.5) ? 1.0 : 0.0, widget.animationSpeedInMilliseconds, widget.globals);
  }

  //-------------------------System Functions

  @override
  Widget build(BuildContext context) {

    widget.linkFunction();

    widget.globals.setAnimationTicker(this);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      //---for bottom and top sheets
      onVerticalDragStart: (widget.isWidthMax) ? onDragStart : null,
      onVerticalDragUpdate: (widget.isWidthMax) ? onDragUpdate : null,
      onVerticalDragEnd: (widget.isWidthMax) ? onDragEnd : null,
      //---for left and right sheets
      onHorizontalDragStart: (widget.isWidthMax) ? null : onDragStart,
      onHorizontalDragUpdate: (widget.isWidthMax) ? null : onDragUpdate,
      onHorizontalDragEnd: (widget.isWidthMax) ? null : onDragEnd,
      child: widget.child,
    );
  }
}

//-------------------------Animation Code-------------------------

completeOpenOrClose(double goalOpenPercent, int millisecondsToComplete, GlobalFunctions globals){
  if(globals.getAnimationOpenOrClose() == null){
    var newOOCA = new OpenOrCloseAnimation(
      startOpenPercent: globals.getOpenPercent(),
      goalOpenPercent: goalOpenPercent,
      millisecondsToComplete: millisecondsToComplete,

      slideUpdateStream: globals.getSlideUpdateStream(),
      vsync: globals.getAnimationTicker(), //NOTE: this assumes you have created an animation ticker already
    );

    globals.setAnimationOpenOrClose(newOOCA);
  }
  else{
    globals.getAnimationOpenOrClose().startOpenPercent = globals.getOpenPercent();
    globals.getAnimationOpenOrClose().goalOpenPercent = goalOpenPercent;
    globals.getAnimationOpenOrClose().millisecondsToComplete = millisecondsToComplete;
    globals.getAnimationOpenOrClose().completionAnimationController.duration = new Duration(milliseconds: millisecondsToComplete);
  }

  globals.getAnimationOpenOrClose().run();
}

//-------------------------Animation Class-------------------------

class OpenOrCloseAnimation{

  AnimationController completionAnimationController;

  double startOpenPercent;
  double goalOpenPercent;
  int millisecondsToComplete;
  StreamController<double> slideUpdateStream;
  TickerProvider vsync;

  OpenOrCloseAnimation({
    @required this.startOpenPercent,
    @required this.goalOpenPercent,
    @required this.millisecondsToComplete,

    //NOTE: these variables are initially passed by the only stateful widget that has a Ticker
    @required this.slideUpdateStream,
    @required this.vsync,
  }){
    completionAnimationController = new AnimationController(
      duration: Duration(milliseconds: millisecondsToComplete),
      vsync: vsync,
    )
      ..addListener((){
        final slidePercent = lerpDouble(
          startOpenPercent,
          goalOpenPercent,
          completionAnimationController.value,
        );

        slideUpdateStream.add(slidePercent);
      });
  }

  run() async{
    completionAnimationController.forward(from: 0.0);
  }
}