import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextOnScreen extends StatelessWidget {
  const TextOnScreen({super.key, required this.imgPath, required this.textOnImage, required this.sW});

  final String imgPath, textOnImage;
  final double sW;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      // alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          imgPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child:

            Stack(
              children: [
                Text(
                  textOnImage.toUpperCase(),
                  style: TextStyle(
                    fontSize: 42 * sW,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = Colors.black,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  textOnImage.toUpperCase(),
                  style: TextStyle(
                    fontSize: 42 * sW,
                    color: Color(0xFF555555).withAlpha(200),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          ),
        )
      ],
    );
  }
}
