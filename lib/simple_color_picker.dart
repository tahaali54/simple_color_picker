library simple_color_picker;

import "package:flutter/material.dart";

//---------------------------SimpleColorPicker.dart-------------------------------
//
//

class SimpleColorPicker extends StatefulWidget {
  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final double height;

  SimpleColorPicker(
      {Key key, @required this.color, @required this.onChanged, this.height})
      : assert(color != null),
        assert(height != null ? height > 0 : true),
        super(key: key);

  @override
  _SimpleColorPickerState createState() => _SimpleColorPickerState();
}

class _SimpleColorPickerState extends State<SimpleColorPicker> {
  HSVColor get color => super.widget.color;
  double get height => super.widget.height;

  //Hue Value
  Offset get hueValueOffset => Offset(this.color.hue, this.color.value);
  void hueValueOnChange(Offset value) =>
      super.widget.onChanged(HSVColor.fromAHSV(
          this.color.alpha, value.dx, this.color.saturation, value.dy));
  //Hue
  final List<Color> hueColors = [
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0),
  ];
  //Value
  final List<Color> valueColors = [Colors.transparent, Colors.black87];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      //Palette
      SizedBox(
          height:
              height != null ? height : MediaQuery.of(context).size.height / 3,
          child: _PalettePicker(
              position: this.hueValueOffset,
              onChanged: this.hueValueOnChange,
              leftPosition: 0.0,
              rightPosition: 360.0,
              leftRightColors: this.hueColors,
              topPosition: 1.0,
              bottomPosition: 0.0,
              topBottomColors: this.valueColors)),
    ]);
  }
}

//
//
//---------------------------SimpleColorPicker.dart-------------------------------

//---------------------------PalettePicker.dart-------------------------------
//
//

class _PalettePicker extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onChanged;

  final double leftPosition;
  final double rightPosition;
  final List<Color> leftRightColors;

  final double topPosition;
  final double bottomPosition;
  final List<Color> topBottomColors;

  _PalettePicker(
      {Key key,
      @required this.position,
      @required this.onChanged,
      this.leftPosition = 0.0,
      this.rightPosition = 1.0,
      @required this.leftRightColors,
      this.topPosition = 0.0,
      this.bottomPosition = 1.0,
      @required this.topBottomColors})
      : assert(position != null),
        super(key: key);

  @override
  _PalettePickerState createState() => _PalettePickerState();
}

class _PalettePickerState extends State<_PalettePicker> {
  final GlobalKey paletteKey = GlobalKey();

  Offset get position => super.widget.position;
  double get leftPosition => super.widget.leftPosition;
  double get rightPosition => super.widget.rightPosition;
  double get topPosition => super.widget.topPosition;
  double get bottomPosition => super.widget.bottomPosition;

  /// Position(min, max) > Ratio(0, 1)
  Offset positionToRatio() {
    double ratioX = this.leftPosition < this.rightPosition
        ? this.positionToRatio2(
            this.position.dx, this.leftPosition, this.rightPosition)
        : 1.0 -
            this.positionToRatio2(
                this.position.dx, this.rightPosition, this.leftPosition);

    double ratioY = this.topPosition < this.bottomPosition
        ? this.positionToRatio2(
            this.position.dy, this.topPosition, this.bottomPosition)
        : 1.0 -
            this.positionToRatio2(
                this.position.dy, this.bottomPosition, this.topPosition);

    return Offset(ratioX, ratioY);
  }

  double positionToRatio2(
      double postiton, double minPostition, double maxPostition) {
    if (postiton < minPostition) return 0.0;
    if (postiton > maxPostition) return 1.0;
    return (postiton - minPostition) / (maxPostition - minPostition);
  }

  /// Ratio(0, 1) > Position(min, max)
  void ratioToPosition(Offset ratio) {
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    Offset startposition = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    Offset updateOffset = ratio - startposition;

    double ratioX = updateOffset.dx / size.width;
    double ratioY = updateOffset.dy / size.height;

    double positionX = this.leftPosition < this.rightPosition
        ? this.ratioToPosition2(ratioX, this.leftPosition, this.rightPosition)
        : this.ratioToPosition2(
            1.0 - ratioX, this.rightPosition, this.leftPosition);

    double positionY = this.topPosition < this.bottomPosition
        ? this.ratioToPosition2(ratioY, this.topPosition, this.bottomPosition)
        : this.ratioToPosition2(
            1.0 - ratioY, this.bottomPosition, this.topPosition);

    Offset position = Offset(positionX, positionY);
    super.widget.onChanged(position);
  }

  double ratioToPosition2(
      double ratio, double minposition, double maxposition) {
    if (ratio < 0.0) return minposition;
    if (ratio > 1.0) return maxposition;
    return ratio * maxposition + (1.0 - ratio) * minposition;
  }

  Widget buildLeftRightColors() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: super.widget.leftRightColors)));
  }

  Widget buildTopBottomColors() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(const Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: super.widget.topBottomColors)));
  }

  Widget buildGestureDetector() {
    return GestureDetector(
        onPanStart: (details) => this.ratioToPosition(details.globalPosition),
        onPanUpdate: (details) => this.ratioToPosition(details.globalPosition),
        onPanDown: (details) => this.ratioToPosition(details.globalPosition),
        child: SizedBox(
            key: this.paletteKey,
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
                painter: _PalettePainter(ratio: this.positionToRatio()))));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      //LeftRightColors
      this.buildLeftRightColors(),

      //TopBottomColors
      this.buildTopBottomColors(),

      //GestureDetector
      this.buildGestureDetector(),
    ]);
  }
}

class _PalettePainter extends CustomPainter {
  _PalettePainter({this.ratio}) : super();

  final Offset ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint paintBlack = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    Offset offset =
        Offset(size.width * this.ratio.dx, size.height * this.ratio.dy);
    canvas.drawCircle(offset, 12, paintBlack);
    canvas.drawCircle(offset, 12, paintWhite);
  }

  @override
  bool shouldRepaint(_PalettePainter other) => true;
}

//
//
//---------------------------PalettePicker.dart-------------------------------
