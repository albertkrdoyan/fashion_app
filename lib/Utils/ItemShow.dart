import 'package:fashion_app/Models/Products.dart';
import 'package:flutter/material.dart';

class ItemShow extends StatefulWidget {
  const ItemShow({super.key, required this.product, required this.sW, required this.imgIndexes, required this.padding});

  final Product product;
  final List imgIndexes;
  final double sW, padding;

  @override
  State<ItemShow> createState() => _ItemShowState();
}

class _ItemShowState extends State<ItemShow> {
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Image.asset(
          'lib/Images/Catalog${widget.product.location}${widget.product.extension}${formatNumber(widget.imgIndexes[initialIndex])}.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: widget.padding),
              height: 25 * widget.sW,
              width: 25 * widget.sW,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    initialIndex--;
                    if (initialIndex == -1){
                      initialIndex = widget.imgIndexes.length - 1;
                    }
                    setState(() {});
                  });
                },
              ),
            ),

            Container(
              padding: EdgeInsets.only(right: widget.padding),
              height: 25 * widget.sW,
              width: 25 * widget.sW,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    initialIndex++;
                    if (initialIndex >= widget.imgIndexes.length){
                      initialIndex = 0;
                    }
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  String formatNumber(int number) {
    if (number < 0 || number > 999) {
      throw ArgumentError('Number must be between 0 and 999.');
    }

    return number.toString().padLeft(3, '0');
  }
}