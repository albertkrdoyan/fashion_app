import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class SvgIconButtonWithStyle extends StatelessWidget {
  const SvgIconButtonWithStyle({super.key, required this.color, required this.svgPath, this.height = 36, this.width = 36});

  final Color color;
  final String svgPath;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width / 375;

    return Container(
      margin: EdgeInsets.all(10 * sW),
      child: Material(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(28 * sW),
        ),
        color: color,
        child: Container(
          height: height * sW,
          width: width * sW,
          padding: EdgeInsets.all(3 * sW),
          child: SvgPicture.string(
            svgPath,
            fit: BoxFit.contain, // or BoxFit.cover if you want it tighter
          ),
        ),
      ),
    );
  }
}
