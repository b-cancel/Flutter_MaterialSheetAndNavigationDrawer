import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';

//-------------------------Enumerations-------------------------

enum sheetPosition { top, right, bottom, left }
enum sheetType { modal, persistent }
enum attachmentPlacement { inside, outside }

//-------------------------Passed Parameters-------------------------

class Parameters{
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

  //if you have too little content you still want your sheet to be a particular size (might have to align)
  final double sheetMin;
  //if you dont want your sheet to be larger than a certain size
  final double sheetMax; //TODO... set inherent limit (max size).... allow overflow to just be scrolled

  Parameters({
    this.app,
    this.sheet,
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

    this.sheetMin,
    this.sheetMax, //TODO... In Progress
  });
}

//-------------------------Private Functions-------------------------

class PrivateFunctions{
  Function getAnimationTicker;
  Function setAnimationTicker;

  Function getAnimationOpenOrClose;
  Function setAnimationOpenOrClose;

  Function getSlideUpdateStream;
  Function setSlideUpdateStream;

  Function getOpenPercent;
  Function setOpenPercent;
}

//-------------------------Public Functions-------------------------

//TODO.... implement these functions
class PublicFunctions{
  //get information
  Function getOpenPercent;
  Function getAttachmentSize;
  Function getSheetSize;
  //execute command
  Function toggleInstantaneous;
  Function toggleAnimated;
  Function openInstantaneous;
  Function closeInstantaneous;
  Function openAnimated;
  Function closeAnimated;
}

//-------------------------The Actual Sheet-------------------------

//NOTE: this has to be stateful because with WidgetsBindingObserver requires it and setState might be called
class Sheet extends StatefulWidget {

  //public
  final Parameters parameters; //USER ASSIGNED
  final functions = new PublicFunctions();

  //private
  final _privateFunctions = new PrivateFunctions();
  final _wholeKey = new GlobalKey(); //container that holds the attachment and the sheet
  final _attachKey = new GlobalKey();

  Sheet({
    @required this.parameters,
  });

  @override
  _SheetWidgetState createState() => new _SheetWidgetState();
}

class _SheetWidgetState extends State<Sheet> with WidgetsBindingObserver{

  //-------------------------Helper Functions

  toggleInstantaneous(){
    if(widget._privateFunctions.getOpenPercent() == 1.0 || widget._privateFunctions.getOpenPercent() == 0.0)
      (widget._privateFunctions.getOpenPercent() == 1.0) ? closeInstantaneous() : openInstantaneous();
  }
  toggleAnimated(){
    if(widget._privateFunctions.getOpenPercent() == 1.0 || widget._privateFunctions.getOpenPercent() == 0.0)
      (widget._privateFunctions.getOpenPercent() == 1.0) ? closeAnimated() : openAnimated();
  }

  //-----Instantaneous
  openInstantaneous() => completeOpenOrClose(1.0, 0, widget._privateFunctions);
  closeInstantaneous() => completeOpenOrClose(0.0, 0, widget._privateFunctions);

  //-----Animated
  openAnimated() => completeOpenOrClose(1.0, widget.parameters.animationSpeedInMilliseconds, widget._privateFunctions);
  closeAnimated() => completeOpenOrClose(0.0, widget.parameters.animationSpeedInMilliseconds, widget._privateFunctions);

  //-------------------------Local Variables

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

  linkPublic(){
    var w = widget.functions;

    w.toggleInstantaneous = toggleInstantaneous;
    w.toggleAnimated = toggleAnimated;
    w.openInstantaneous = openInstantaneous;
    w.closeInstantaneous = closeInstantaneous;
    w.openAnimated = openAnimated;
    w.closeAnimated = closeAnimated;
  }

  linkPrivate(){

    //print("link");

    var w = widget._privateFunctions;

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
    await linkPrivate();
    _initGlobalVar();
  }

  //-------------------------Required For Gestures and Animations

  _initGlobalVar() {
    if(widget._privateFunctions.getSlideUpdateStream() == null){
      widget._privateFunctions.setSlideUpdateStream(new StreamController<double>());

      widget._privateFunctions.getSlideUpdateStream().stream.listen((double newPercent){
        setState(() {
          widget._privateFunctions.setOpenPercent(newPercent);
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
    bool override = widget.parameters.backBtnClosesSheet && (widget._privateFunctions.getOpenPercent() ==  1.0);
    if(override)
      (widget.parameters.backBtnClosesAnimated) ? closeAnimated() : closeInstantaneous();
    return new Future<bool>.value(override);
  }

  //-------------------------Helper Functions

  Matrix4 _calcSheetClosedTransform(bool isWidthMax, double width, double height){

    width = width ?? 0.0;
    height = height ?? 0.0;

    if(isWidthMax){ //mess with y
      if(widget.parameters.position == sheetPosition.top) return Matrix4.translationValues(0.0, -height, 0.0);
      else return Matrix4.translationValues(0.0, height, 0.0);
    } else{ //mess with x
      if(widget.parameters.position == sheetPosition.right) return Matrix4.translationValues(width, 0.0, 0.0);
      else return Matrix4.translationValues(-width, 0.0, 0.0);
    }
  }

  BoxConstraints _calcBoxConstraints(bool fullWidth) {
    if (widget.parameters.sheetMin == null && widget.parameters.sheetMax == null)
      return new BoxConstraints();
    else {
      if (widget.parameters.sheetMin != null && widget.parameters.sheetMax != null) {
        if (fullWidth) //we only care for height
          return new BoxConstraints(
            minHeight: widget.parameters.sheetMin,
            maxHeight: widget.parameters.sheetMax,
          );
        else //we only care for width
          return new BoxConstraints(minWidth: widget.parameters.sheetMin, maxWidth: widget.parameters.sheetMax);
      } else {
        if (widget.parameters.sheetMin != null) {
          //we only have min
          if (fullWidth) //we only care for height
            return new BoxConstraints(minHeight: widget.parameters.sheetMin);
          else //we only care for width
            return new BoxConstraints(minWidth: widget.parameters.sheetMin);
        } else {
          //we only have max
          if (fullWidth) //we only care for h`eight
            return new BoxConstraints(maxHeight: widget.parameters.sheetMax);
          else //we only care for width
            return new BoxConstraints(maxWidth: widget.parameters.sheetMax);
        }
      }
    }
  }

  //ONLY relevant if position is top or bottom
  TextDirection _calcTextDirection(){
    if(widget.parameters.position == sheetPosition.right){
      if(widget.parameters.placement == attachmentPlacement.inside) return TextDirection.rtl;
      else return TextDirection.ltr;
    }else{
      if(widget.parameters.placement == attachmentPlacement.inside) return TextDirection.ltr;
      else return TextDirection.rtl;
    }
  }

  //ONLY relevant if position is left or right
  VerticalDirection _calcVerticalDirection(){
    if(widget.parameters.position == sheetPosition.top){
      if(widget.parameters.placement == attachmentPlacement.inside) return VerticalDirection.down;
      else return VerticalDirection.up;
    }else{
      if(widget.parameters.placement == attachmentPlacement.inside) return VerticalDirection.up;
      else return VerticalDirection.down;
    }
  }

  Matrix4 _calcTransform(bool isWidthMax, double width, double height){
    Matrix4 beginMatrix = Matrix4.translationValues(0.0,0.0,0.0);
    Matrix4 endMatrix = _calcSheetClosedTransform(isWidthMax, width, height);
    return Matrix4Tween(begin: endMatrix, end: beginMatrix).lerp(widget._privateFunctions.getOpenPercent());
  }

  Color _calcIndicatorColor(){
    if(widget.parameters.autoOpenOrCloseIndicator){
      if(widget._privateFunctions.getOpenPercent() > .5) return widget.parameters.indicatorAutoCloseColor.withOpacity(0.0);
      else return widget.parameters.indicatorAutoCloseColor;
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
          child: widget.parameters.sheet,
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
    Widget currAttach = widget.parameters.attachment;
    if(currAttach == null && widget.parameters.swipeToOpen)
      currAttach = new Icon(Icons.attachment, color: Colors.transparent);

    return new Container(
      key: (addKey) ? widget._attachKey : null,
      child: (currAttach != null) ? currAttach : null,
    );
  }

  Widget scrimWidget(){
    if(widget.parameters.type == sheetType.modal){
      if(widget._privateFunctions.getOpenPercent() != 0.0){
        return new Container(
          color: Color.lerp(Colors.transparent, widget.parameters.scrimOpenColor, widget._privateFunctions.getOpenPercent()),
          child: new GestureDetector(
            onTap: (widget.parameters.backBtnClosesAnimated) ? closeAnimated() : closeInstantaneous(),
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
    double wholeWidth = widget._wholeKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.width;
    double wholeHeight = widget._wholeKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.height;
    double attachWidth = widget._attachKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.width;
    double attachHeight = widget._attachKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.height;

    double sheetWidth = (wholeWidth == null)
        ? 0.0
        : (wholeWidth == attachWidth) ? wholeWidth : wholeWidth - attachWidth;
    double sheetHeight = (wholeHeight == null)
        ? 0.0
        : (wholeHeight == attachHeight) ? wholeHeight : wholeHeight - attachHeight;

    bool isWidthMax = (widget.parameters.position == sheetPosition.bottom || widget.parameters.position == sheetPosition.top);

    Widget thisSheetWidget = sheetWidget(sheetWidth, sheetHeight);

    Transform mainWidget = new Transform(
      transform: _calcTransform(isWidthMax, sheetWidth, sheetHeight),
      child: new Flex(
        direction: (isWidthMax)
            ? Axis.vertical
            : Axis.horizontal,
        //ONLY relevant if position is top or bottom
        textDirection: (widget.parameters.position == sheetPosition.right)
            ? TextDirection.ltr
            : TextDirection.rtl,
        //ONLY relevant if position is left or right
        verticalDirection: (widget.parameters.position == sheetPosition.top)
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
              key: widget._wholeKey,
              color: Colors.transparent,
              child: new SwipeToOpenClose(
                linkFunction: asyncLink,
                globals: widget._privateFunctions,
                isWidthMax: isWidthMax,
                position: widget.parameters.position,
                sheetWidth: sheetWidth,
                sheetHeight: sheetHeight,
                swipeToOpen: widget.parameters.swipeToOpen,
                swipeToClose: widget.parameters.swipeToClose,
                animationSpeedInMilliseconds: widget.parameters.animationSpeedInMilliseconds,
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

    if(widget.parameters.placement == attachmentPlacement.inside){
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
              textDirection: (widget.parameters.position == sheetPosition.right)
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              //ONLY relevant if position is left or right
              verticalDirection: (widget.parameters.position == sheetPosition.top)
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

    linkPrivate();

    if(widget._privateFunctions.getOpenPercent() == null)
      widget._privateFunctions.setOpenPercent((widget.parameters.startOpen) ? 1.0 : 0.0);

    //---Required to read in sheetWidth and sheetHeight
    timesBuilt++;
    if(timesBuilt < requiredBuildsPerChange) rebuildAsync();
    else timesBuilt = 0;

    return new MediaQuery(
      data: MediaQueryData(),
      child: new Directionality(
        textDirection: TextDirection.ltr,
        child: new Stack(
          children: <Widget>[
            widget.parameters.app,
            new Stack(
              children: <Widget>[
                scrimWidget(),
                sheetAndAttachmentWidget(),
              ],
            ),
          ],
        ),
      ),
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

  final PrivateFunctions globals;

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

completeOpenOrClose(double goalOpenPercent, int millisecondsToComplete, PrivateFunctions globals){
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