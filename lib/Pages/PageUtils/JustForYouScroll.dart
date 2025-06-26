import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/DrawPageIndicator.dart';

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

class JustForYouSection extends StatefulWidget {
  const JustForYouSection({super.key, required this.justForYouSectionController, required this.items, required this.sW, required this.count});

  final PageController justForYouSectionController;
  final List items;
  final double sW;
  final int count;

  @override
  State<JustForYouSection> createState() => _JustForYouSectionState();
}

class _JustForYouSectionState extends State<JustForYouSection> {
  int initialIndex = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink(); // or some "No items found" message
    }

    List newList = getRandomElements(widget.count, widget.items);

    return SizedBox(
      height: 390 * widget.sW,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: widget.justForYouSectionController,
        itemCount: widget.count,
        padding: EdgeInsets.symmetric(horizontal: 16 * widget.sW),
        itemBuilder:(context, index) => SizedBox(
            width: 255 * widget.sW,
            key: ValueKey(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  key: ValueKey(index),
                  width: 255 * widget.sW,
                  height: 280 * widget.sW,
                  child: ItemShow(
                    key: ValueKey(index),
                    index: index,
                    catItemsList: newList,
                    sW: widget.sW,
                    imgIndexes: List.generate(
                      newList[index]['extension'][1] - 2,
                          (index_) => index_ + 1,
                    ),
                    padding: 255 * widget.sW * 0.01,
                  ),
                ),

                Text(
                  (newList[index]['name'].length < 44
                      ? '${newList[index]['name']}'
                      : '${newList[index]['name'].toString().substring(0, 41)}..'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tenorSans(
                      fontSize: 18 * widget.sW,
                      color: Color(0xFF333333)
                  ),
                ),

                Text(
                  '\$${newList[index]['price']}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tenorSans(
                      fontSize: 22 * widget.sW,
                      color: Color(0xFFDD8560),
                      fontWeight: FontWeight.w500
                  ),
                )
              ],
            )
        ),
        separatorBuilder: (context, index) => SizedBox(width: 11 * widget.sW,),
      ),
    );
  }

  List getRandomElements(int count, List items) {
    List indices = List.generate(items.length, (index) => index);
    indices.shuffle();

    return List.generate(count, (index) => items[indices[index]],);
  }
}