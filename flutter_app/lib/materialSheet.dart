import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

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

      //TODO... In Progress
      this.sheetMin,
      this.sheetMax,
      this.verticalScrollOnOverflow: false,
      this.horizontalScrollOnOverflow: false,
      this.swipeToOpen: true,
      this.swipeToClose: true,
      this.closeBarAutoAppear: false,
      this.willAutoOpenOrAutoCloseIndicator: true,
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

  //---------TODO... In Progress
  //if you have too little content you still want your sheet to be a particular size (might have to align)
  final double sheetMin; //TODO... check if I need alignment var addition
  //if you dont want your sheet to be larger than a certain size
  final double sheetMax; //TODO... set inherent limit (max size).... allow overflow to just be scrolled
  //if you drag the sheet but not all the way after 50% on either side it will open or close automatically
  //this will show an indicator when the action that will be taken is obvious
  //darker overlay means it will close, no overlay means it will open
  final bool willAutoOpenOrAutoCloseIndicator; //TODO...

  //TODO... DECIDE (all transparent gesture detectors)
  //swipe anywhere on screen?!
  //swipe only from dragging invisible edge?!
  //swipe only from dragging attachment container?! (if exists)
  final bool swipeToOpen; //TODO
  //TODO... DECIDE (2 gesture detectors, modal sheet area can have transparent, sheet and attachment area MUST have opaque)
  //swipe anywhere on screen?!
  //swipe only the sheet itself?!
  //swipe only on the attachment?!
  //swipe only on the modal sheet?! (if exists)
  final bool swipeToClose; //TODO

  final bool verticalScrollOnOverflow; //TODO
  final bool horizontalScrollOnOverflow; //TODO

  //EX: if you sheet is a bottom sheet and your content fills the screen vertically,
  //  you have a bar to close the entire sheet (as suggested by material design)
  final bool closeBarAutoAppear; //TODO

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
                  sheet: sheet,
                  attachment: attachment,

                  getOpenPercent: getOpenPercent,
                  setOpenPercent: setOpenPercent,

                  position: position,
                  type: type,
                  placement: placement,
                  backBtnClosesSheet: backBtnClosesSheet,

                  closeSheetFunc: closeSheet,

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
    @required this.sheet,
    @required this.attachment,

    @required this.getOpenPercent,
    @required this.setOpenPercent,
    @required this.position,
    @required this.type,
    @required this.placement,
    @required this.backBtnClosesSheet,

    @required this.closeSheetFunc,

    //TODO... in progress
    @required this.sheetMin,
    @required this.sheetMax,
  }) : super(key: key);

  final Widget sheet;
  final Widget attachment;

  final Function getOpenPercent;
  final Function setOpenPercent;
  final sheetPosition position;
  final sheetType type;
  final attachmentPlacement placement;
  final bool backBtnClosesSheet;

  final Function closeSheetFunc;

  //TODO... in progress
  final double sheetMin;
  final double sheetMax;

  @override
  _SheetWidgetState createState() => new _SheetWidgetState();
}

var sheetKey = new GlobalKey();

class _SheetWidgetState extends State<SheetWidget> with WidgetsBindingObserver{

  //-------------------------Parameters

  static Widget sheet;
  static Widget attachment;

  static Function getOpenPercent;
  static Function setOpenPercent;
  static sheetPosition position;
  static sheetType type;
  static attachmentPlacement placement;
  static bool backBtnClosesSheet;

  static Function closeSheetFunc;

  //TODO... in progress
  static double sheetMin;
  static double sheetMax;


  void _tieVarsOnInit() {
    sheet = widget.sheet;
    attachment = widget.attachment;

    getOpenPercent = widget.getOpenPercent;
    setOpenPercent = widget.setOpenPercent;

    position = widget.position;
    type = widget.type;
    placement = widget.placement;
    backBtnClosesSheet = widget.backBtnClosesSheet;

    closeSheetFunc = widget.closeSheetFunc;

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
      child:
      new Flex(
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
                        child: thisSheetWidget,
                      ),
                      thisAttachmentWidget,
                    ],
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
          new Flex(
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
        ],
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

    Widget thisAttachmentWidget = new Container(
      color: Colors.greenAccent,
      child: (attachment != null) ? attachment : null,
    );

    return new Stack(
      children: <Widget>[
        scrimWidget(),
        sheetAndAttachmentWidget(isWidthMax, sheetWidth, sheetHeight, thisSheetWidget, thisAttachmentWidget),
        new SwipeToOpenClose(
          isWidthMax: isWidthMax,
          position: position,
          sheetWidth: sheetWidth,
          sheetHeight: sheetHeight,

          getOpenPercent: getOpenPercent,

          slideUpdateStream: slideUpdateStream,
        ),
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

    @required this.getOpenPercent,

    @required this.slideUpdateStream,
  });

  final bool isWidthMax;
  final sheetPosition position;
  final double sheetWidth;
  final double sheetHeight;

  final Function getOpenPercent;

  final StreamController<double> slideUpdateStream;

  @override
  _SwipeToOpenCloseState createState() => _SwipeToOpenCloseState();
}

class _SwipeToOpenCloseState extends State<SwipeToOpenClose> with TickerProviderStateMixin{

  Offset dragStart;
  double slideStart;

  AnimatedOpenOrClose animatedOpenOrClose;

  onDragStart(DragStartDetails details){
    dragStart = details.globalPosition;
    slideStart = widget.getOpenPercent();
  }

  onDragUpdate(DragUpdateDetails details){
    if(dragStart != null){
      final dragCurrent = details.globalPosition;
      final dragChange = dragStart - dragCurrent;

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

    animatedOpenOrClose = new AnimatedOpenOrClose(
      startOpenPercent: widget.getOpenPercent(),
      goalOpenPercent: (widget.getOpenPercent() > 0.5) ? 1.0 : 0.0,
      slideUpdateStream: widget.slideUpdateStream,
      vsync: this,
    );

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
    );
  }
}

//-------------------------Animation Code-------------------------

class AnimatedOpenOrClose{

  AnimationController completionAnimationController;

  final startOpenPercent;
  final goalOpenPercent;

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
    await completionAnimationController.forward(from: 0.0);
    dispose();
  }

  dispose(){
    completionAnimationController.dispose();
    this.dispose();
  }
}
