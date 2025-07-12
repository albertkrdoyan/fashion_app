import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({super.key, required this.onTap, required this.buttonText, required this.backColor, required this.textColor, this.image,});

  final VoidCallback onTap;
  final String buttonText;
  final Color backColor, textColor;
  final String? image;

  @override
  Widget build(BuildContext context) {
    double screenWidth = 0, screenHeight = 0;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialButton(
      onPressed: onTap,
      color: backColor,
      minWidth: screenWidth * 0.90,
      height: screenHeight * 0.07,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(image != null)...[
              SizedBox(
                height: screenHeight * 0.05,
                width: screenHeight * 0.05,
                child: Image.asset(image!),
              ),
            ],

            Text(
              buttonText,
              style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  letterSpacing: 2,
                  color: textColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
