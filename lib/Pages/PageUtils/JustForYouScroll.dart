import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/DrawPageIndicator.dart';
import '../../Utils/JustForYouSection.dart';

class JustForYouScroll extends StatelessWidget {
  JustForYouScroll({super.key, required this.sW, required this.itemList});

  final double sW;
  final List itemList;

  final justForYouSectionController = PageController(viewportFraction: 0.68);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 531 * sW,
      width: 375 * sW,
      child: Column(
        children: [
          SizedBox(height: 45 * sW,),

          Text(
            'JUST FOR YOU',
            style: GoogleFonts.tenorSans(
                color: Colors.black,
                letterSpacing: 10,
                fontSize: 20 * sW
            ),
          ),

          SizedBox(
            width: 125 * sW,
            height: 9.25 * sW,
            child: Image.asset(
              'lib/Images/HomePage/Logo/Line.png',
              color: Colors.black,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 22 * sW,),

          JustForYouSection(
            justForYouSectionController: justForYouSectionController,
            items: itemList,
            sW: sW,
            count: 5,
          ),

          SizedBox(height: 17 * sW,),

          DrawPageIndicator(controller: justForYouSectionController, size: 6.5 * sW, count: 5,),

          // SizedBox(height: screenHeight * 0.04,),
        ],
      ),
    );
  }
}
