import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

//TODO... create animated open and close an
//TODO... rename current versions as immediate open and close
//TODO... gesture detector of modal (full screen) gesture detector of persistent (only sheet)
//TODO... refactor like crazy
//TODO... added need options as consequence of sheetMin and sheetMax
//TODO... add vertical and horionztal scrolling

//-------------------------Scoped Model-------------------------

class SheetState extends Model {
  double _openPercent;
  double get openPercent => _openPercent;
  set openPercent(double newPercentOpen){
    _openPercent = newPercentOpen.clamp(0.0, 1.0);
    notifyListeners();
  }
  SheetState(this._openPercent);
}

//-------------------------Enumerations-------------------------

enum sheetPosition { top, right, bottom, left }
enum sheetType { modal, persistent }
enum attachmentPlacement { inside, outside }

//-------------------------Material Sheet-------------------------

//NOTE: this has to be stateless so that I can address the sheetOpen and sheetClose Functions
class MaterialSheet extends StatelessWidget {

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
      this.autoOpenOrCloseIndicator: false,

      this.swipeToOpen: true,
      this.swipeToClose: true,

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
  //if you drag the sheet but not all the way after 50% on either side it will open or close automatically
  //this will show an indicator when the action that will be taken is obvious
  //darker overlay means it will close, no overlay means it will open
  final bool autoOpenOrCloseIndicator;

  final bool swipeToOpen;
  final bool swipeToClose;

  //---------TODO... In Progress
  //if you have too little content you still want your sheet to be a particular size (might have to align)
  final double sheetMin; //TODO... check if I need alignment var addition
  //if you dont want your sheet to be larger than a certain size
  final double sheetMax; //TODO... set inherent limit (max size).... allow overflow to just be scrolled

  //-------------------------Local Variables

  SheetState _currSheetState;

  //-------------------------Helper Functions

  openSheet() => _currSheetState.openPercent = 1.0;
  closeSheet() => _currSheetState.openPercent = 0.0;

  double getOpenPercent(){
    return _currSheetState.openPercent;
  }

  void setOpenPercent(double newOpenPercent){
    _currSheetState.openPercent = newOpenPercent;
  }

  //-------------------------Build Method

  @override
  Widget build(BuildContext context) {

    if(_currSheetState == null)
      _currSheetState = new SheetState((startOpen) ? 1.0 : 0.0);

    return new ScopedModel<SheetState>(
      model: _currSheetState,
      child: new MediaQuery(
        data: MediaQueryData(),
        child: new Directionality(
          textDirection: TextDirection.ltr,
          child: new Stack(
            children: <Widget>[
              app,
              new ScopedModelDescendant<SheetState>(
                builder: (context, child, model) => new SheetWidget(
                  closeSheetFunc: closeSheet,

                  getOpenPercent: getOpenPercent,
                  setOpenPercent: setOpenPercent,

                  sheet: sheet,
                  attachment: attachment,

                  position: position,
                  type: type,
                  placement: placement,
                  backBtnClosesSheet: backBtnClosesSheet,
                  autoOpenOrCloseIndicator: autoOpenOrCloseIndicator,

                  swipeToOpen: swipeToOpen,
                  swipeToClose: swipeToClose,

                  //TODO... in progress
                  sheetMin: sheetMin,
                  sheetMax: sheetMax,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------------The Actual Sheet-------------------------

//NOTE: this has to be stateful because with WidgetsBindingObserver requires it
class SheetWidget extends StatefulWidget {

  //-------------------------Parameters

  const SheetWidget({
    Key key,

    @required this.closeSheetFunc,

    @required this.getOpenPercent,
    @required this.setOpenPercent,

    @required this.sheet,
    @required this.attachment,

    @required this.position,
    @required this.type,
    @required this.placement,
    @required this.backBtnClosesSheet,
    @required this.autoOpenOrCloseIndicator,

    @required this.swipeToOpen,
    @required this.swipeToClose,

    //TODO... in progress
    @required this.sheetMin,
    @required this.sheetMax,
  }) : super(key: key);

  final Function closeSheetFunc;

  final Function getOpenPercent;
  final Function setOpenPercent;

  final Widget sheet;
  final Widget attachment;

  final sheetPosition position;
  final sheetType type;
  final attachmentPlacement placement;
  final bool backBtnClosesSheet;
  final bool autoOpenOrCloseIndicator;

  final bool swipeToOpen;
  final bool swipeToClose;

  //TODO... in progress
  final double sheetMin;
  final double sheetMax;

  @override
  _SheetWidgetState createState() => new _SheetWidgetState();
}

var sheetKey = new GlobalKey();

class _SheetWidgetState extends State<SheetWidget> with WidgetsBindingObserver{

  //-------------------------Parameters

  static Function closeSheetFunc;

  static Function getOpenPercent;
  static Function setOpenPercent;

  static Widget sheet;
  static Widget attachment;

  static sheetPosition position;
  static sheetType type;
  static attachmentPlacement placement;
  static bool backBtnClosesSheet;
  static bool autoOpenOrCloseIndicator;

  static bool swipeToOpen;
  static bool swipeToClose;

  //TODO... in progress
  static double sheetMin;
  static double sheetMax;

  void _tieVarsOnInit() {
    closeSheetFunc = widget.closeSheetFunc;

    getOpenPercent = widget.getOpenPercent;
    setOpenPercent = widget.setOpenPercent;

    sheet = widget.sheet;
    attachment = widget.attachment;
    position = widget.position;
    type = widget.type;
    placement = widget.placement;
    backBtnClosesSheet = widget.backBtnClosesSheet;
    autoOpenOrCloseIndicator = widget.autoOpenOrCloseIndicator;

    swipeToOpen = widget.swipeToOpen;
    swipeToClose = widget.swipeToClose;

    //TODO.... in progress
    sheetMin = widget.sheetMin;
    sheetMax = widget.sheetMax;
  }

  //-------------------------Local Variables


  //for gestures and animations
  StreamController<double> slideUpdateStream;

  //for back button override functionality
  int requiredBuildsPerChange = 2;
  int timesBuilt = 0;

  //-------------------------Required For Reading in sheetWidth and sheetHeight

  rebuildAsync() async{
    await Future.delayed(Duration.zero);
    setState(() {});
  }

  //-------------------------Required For Gestures and Animations

  _SheetWidgetState() {
    slideUpdateStream = new StreamController<double>();

    slideUpdateStream.stream.listen((double newPercent){
      setOpenPercent(newPercent);
    });
  }

  //-------------------------Required For WidgetsBindingObserver

  @override
  void initState() {
    _tieVarsOnInit();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //-------------------------Function That Triggers when you hit the back key

  @override
  didPopRoute(){
    bool override = backBtnClosesSheet && (getOpenPercent() !=  0.0);
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
    return Matrix4Tween(begin: endMatrix, end: beginMatrix).lerp(getOpenPercent());
  }

  Color _calcIndicatorColor(){
    if(autoOpenOrCloseIndicator){
      if(getOpenPercent() > .5) return Colors.black.withOpacity(0.0);
      else return Colors.black.withOpacity(.5);
    }
    else return Colors.transparent;
  }

  //-------------------------Helper Widget Extracts

  Widget scrimWidget(){
    if(type == sheetType.modal){
      if(getOpenPercent() != 0.0){
        return new Container(
          color: Colors.black.withOpacity(0.0 * (1.0 - getOpenPercent()) + .5 * getOpenPercent()),
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

  Widget sheetAndAttachmentWidget(
      bool isWidthMax,
      double sheetWidth,
      double sheetHeight,
      Widget thisSheetWidget,
      Widget thisAttachmentWidget)
  {
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
              color: Colors.transparent,
              child: new IntrinsicWidth(
                child: new IntrinsicHeight(
                  child:  new SwipeToOpenClose(
                    isWidthMax: isWidthMax,
                    position: position,
                    sheetWidth: sheetWidth,
                    sheetHeight: sheetHeight,
                    getOpenPercent: getOpenPercent,
                    slideUpdateStream: slideUpdateStream,
                    swipeToOpen: swipeToOpen,
                    swipeToClose: swipeToClose,
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
                        new Expanded(
                          child: new Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                thisSheetWidget,
                                new IgnorePointer(
                                  child: new Container(
                                    color: _calcIndicatorColor(),
                                  ),
                                )
                              ]
                          ),
                        ),
                        thisAttachmentWidget,
                      ],
                    ),
                  ),
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
                thisAttachmentWidget,
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget attachmentWidget(){

    if(attachment == null && swipeToOpen){
      return Container(
        child: (attachment != null) ?
        attachment : new Icon(
          Icons.attachment,
          color: Colors.transparent,
        ),
      );
    }
    else{
      return Container(
        color: Colors.greenAccent,
        child: (attachment != null) ?
        attachment : null,
      );
    }
  }

  //-------------------------Build Method

  @override
  Widget build(BuildContext context) {

    //---reading in both values

    double sheetWidth = sheetKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.width;
    double sheetHeight = sheetKey?.currentContext?.findRenderObject()?.semanticBounds?.size?.height;

    //---Required to read in sheetWidth and sheetHeight
    timesBuilt++;
    if(timesBuilt < requiredBuildsPerChange)
      rebuildAsync();
    else
      timesBuilt = 0;

    //---simplifies ops below
    bool isWidthMax =
    (position == sheetPosition.bottom || position == sheetPosition.top);

    Widget thisSheetWidget = new Container(
      key: sheetKey,
      color: Colors.amberAccent,
      child: sheet,
    );

    Widget thisAttachmentWidget = attachmentWidget();

    return new Stack(
      children: <Widget>[
        scrimWidget(),
        sheetAndAttachmentWidget(isWidthMax, sheetWidth, sheetHeight, thisSheetWidget, thisAttachmentWidget),
      ],
    );
  }
}

//-------------------------GestureDetector Code-------------------------

class SwipeToOpenClose extends StatefulWidget {

  SwipeToOpenClose({
    @required this.isWidthMax,
    @required this.position,
    @required this.sheetWidth,
    @required this.sheetHeight,

    @required this.swipeToOpen,
    @required this.swipeToClose,

    @required this.getOpenPercent,

    @required this.slideUpdateStream,

    @required this.child,
  });

  final bool isWidthMax;
  final sheetPosition position;
  final double sheetWidth;
  final double sheetHeight;

  final bool swipeToOpen;
  final bool swipeToClose;

  final Function getOpenPercent;

  final StreamController<double> slideUpdateStream;

  final Widget child;

  @override
  _SwipeToOpenCloseState createState() => _SwipeToOpenCloseState();
}

class _SwipeToOpenCloseState extends State<SwipeToOpenClose> with SingleTickerProviderStateMixin{

  Offset dragStart;
  double slideStart;

  AnimatedOpenOrClose animatedOpenOrClose;

  onDragStart(DragStartDetails details){
    slideStart = widget.getOpenPercent();
    dragStart = details.globalPosition;

    //NOTE: because our animation will complete any drag...
    //whenever we drag we will begin dragging our slideStart will be 0.0 or 1.0
    if(slideStart == 0.0 && widget.swipeToOpen == false)
      slideStart = null;
    if(slideStart == 1.0 && widget.swipeToClose == false)
      slideStart = null;
  }

  onDragUpdate(DragUpdateDetails details){
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

      widget.slideUpdateStream.add((slideStart + slideAdded).clamp(0.0, 1.0));
    }
  }

  onDragEnd(DragEndDetails details){
    dragStart = null;
    animateOpenClose((widget.getOpenPercent() > 0.5) ? 1.0 : 0.0);
  }

  animateOpenClose(double goalOpenPercent){
    if(animatedOpenOrClose == null){
      animatedOpenOrClose = new AnimatedOpenOrClose(
        startOpenPercent: widget.getOpenPercent(),
        goalOpenPercent: goalOpenPercent,
        slideUpdateStream: widget.slideUpdateStream,
        vsync: this,
      );
    }
    else{
      animatedOpenOrClose.startOpenPercent = widget.getOpenPercent();
      animatedOpenOrClose.goalOpenPercent = goalOpenPercent;
    }

    animatedOpenOrClose.run();
  }

  @override
  Widget build(BuildContext context) {
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

class AnimatedOpenOrClose{

  AnimationController completionAnimationController;

  double startOpenPercent;
  double goalOpenPercent;

  AnimatedOpenOrClose({
    this.startOpenPercent,
    this.goalOpenPercent,
    StreamController<double> slideUpdateStream,
    TickerProvider vsync,
  }){
    //100 milliseconds is instant, 200 milliseconds is instant with an animation
    const millisecondsToComplete = 100;

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

  dispose(){
    completionAnimationController.dispose();
    this.dispose();
  }
}
