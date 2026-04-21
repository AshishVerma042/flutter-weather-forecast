import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


Visibility progressBar(value, h, w) {
  return Visibility(
    visible: value,
    child: Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.black.withValues(alpha: 0.6),
          Colors.black.withValues(alpha: 0.8),
        ],
      )),
      child: Center(
          child: LoadingAnimationWidget.dotsTriangle(
        color: Colors.deepPurpleAccent,
        size: h * 0.05,
      )),
    ),
  );
}

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 20.0,
      color: Colors.white,
    );
  }
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({super.key, required this.lineType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lineType == ContentLineType.twoLines ? 2 : 3, (index) {
        return Container(
          width: double.infinity,
          height: 15.0,
          margin: const EdgeInsets.only(bottom: 8.0),
          color: Colors.white,
        );
      }),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}
