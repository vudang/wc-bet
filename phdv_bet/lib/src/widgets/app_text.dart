import 'package:flutter/cupertino.dart';
import 'package:web_dashboard/src/color.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight weight;
  final Color color;
  final TextAlign align;
  final FontStyle fontStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? linHeight;
  final List<Shadow>? shadows;
  final double? letterSpacing;

  const AppText(this.text,
      {Key? key,
      this.size,
      this.weight = FontWeight.normal,
      this.color = SystemColor.BLACK,
      this.align = TextAlign.left,
      this.fontStyle = FontStyle.normal,
      this.maxLines,
      this.overflow,
      this.linHeight,
      this.shadows,
      this.letterSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      softWrap: true,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
          fontSize: size ?? 17,
          fontWeight: weight,
          color: color,
          fontStyle: fontStyle,
          height: linHeight,
          letterSpacing: letterSpacing ?? 0,
          shadows: shadows),
    );
  }
}
