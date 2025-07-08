import 'dart:math' as math;

import 'package:flutter/material.dart';

class LinePattern extends StatelessWidget {
  const LinePattern({super.key, required this.backColor, required this.color, this.width = 125, this.withSquare = true});

  final Color backColor, color;
  final double width;
  final bool withSquare;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: color,
          width: width * sW,
          height: 1 * sH,
        ),
        if (withSquare)
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 6.54 * sW,
            height: 6.54 * sW,
            decoration: BoxDecoration(
                color: backColor,
                border: BoxBorder.all(
                  color: color,
                  width: 1 * sW,
                )
            ),
          ),
        )
      ],
    );
  }
}
