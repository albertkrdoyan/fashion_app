import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DrawPageIndicator extends StatelessWidget {
  const DrawPageIndicator({super.key, required this.controller, required this.size, required this.count, this.selectedItemColor = Colors.white});

  final PageController controller;
  final double size;
  final int count;
  final Color selectedItemColor;

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
              color: selectedItemColor,
            ),
            width: size,
            height: size
          ),
          activeDotDecoration: DotDecoration(
            color: selectedItemColor,
            rotationAngle: 45,
            dotBorder: DotBorder(
              width: 1,
              color: selectedItemColor
            ),
            width: size,
            height: size
          ),
        ),
      ),
    );
  }
}
