import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DrawPageIndicator extends StatelessWidget {
  const DrawPageIndicator({super.key, required this.controller, required this.size, required this.count});

  final PageController controller;
  final double size;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SmoothPageIndicator(
        onDotClicked: (index) => controller.jumpToPage(index),
        controller: controller,
        count: count,
        effect: CustomizableEffect(
          dotDecoration: DotDecoration(
            color: Colors.transparent,
            rotationAngle: 45,
            dotBorder: DotBorder(
              width: 1,
              color: Colors.white,
            ),
            width: size,
            height: size
          ),
          activeDotDecoration: DotDecoration(
            color: Colors.white,
            rotationAngle: 45,
            dotBorder: DotBorder(
              width: 1,
              color: Colors.white
            ),
            width: size,
            height: size
          ),
        ),
      ),
    );
  }
}
