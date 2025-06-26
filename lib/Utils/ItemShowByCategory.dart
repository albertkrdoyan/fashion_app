import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemShowByCategory extends StatefulWidget {
  const ItemShowByCategory({super.key, required this.category, required this.itemList, required this.sW});

  final List itemList;
  final String category;
  final double sW;

  @override
  State<ItemShowByCategory> createState() => _ItemShowByCategoryState();
}

class _ItemShowByCategoryState extends State<ItemShowByCategory> {
  @override
  Widget build(BuildContext context) {
    List catItemsList = listByCategory();
    catItemsList.shuffle();

    return SizedBox(
      height: 610 * widget.sW,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * widget.sW, vertical: 13 * widget.sW),
        child: MasonryGridView.count(
          key: ValueKey(widget.key),
          itemCount: catItemsList.length > 4 ? 4 : catItemsList.length,
          crossAxisCount: 2,
          crossAxisSpacing: 13 * widget.sW,
          mainAxisSpacing: 11 * widget.sW,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SizedBox(
              key: ValueKey(index),
              height: 265 * widget.sW,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    key: ValueKey(index),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(
                        color: Color(0xFF888888).withAlpha(75),
                        width: 1
                      ),
                    ),
                    height: 200 * widget.sW,
                    width: 165 * widget.sW,
                    child: ItemShow(
                      key: ValueKey(index),
                      index: index,
                      catItemsList: catItemsList,
                      sW: widget.sW,
                      imgIndexes: [catItemsList[index]['extension'][1] - 1, catItemsList[index]['extension'][1]],
                      padding: 165 * widget.sW * 0.01,
                    )
                  ),

                  Text(
                    (catItemsList[index]['name'].length < 44
                        ? catItemsList[index]['name']
                        : '${catItemsList[index]['name'].toString().substring(0, 41)}..'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenorSans(
                        fontSize: 14 * widget.sW,
                        color: Color(0xFF333333)
                    ),
                  ),

                  Text(
                    '\$${catItemsList[index]['price']}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenorSans(
                        fontSize: 16 * widget.sW,
                        color: Color(0xFFDD8560)
                    ),
                  )
                ],
              )
            );
          },
        ),
      ),
    );
  }

  List listByCategory(){
    if (widget.category == "All") return widget.itemList;

    List catItemsList = [];

    for (int i = 0; i < widget.itemList.length; ++i){
      if (widget.itemList[i]['category'] == widget.category){
        catItemsList.add(widget.itemList[i]);
      }
    }

    return catItemsList;
  }
}