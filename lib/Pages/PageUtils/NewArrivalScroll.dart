import 'package:fashion_app/Products/Products.dart';
import 'package:fashion_app/Provider/CatalogProvider.dart';
import 'package:fashion_app/Provider/categoriesProvider.dart';
import 'package:fashion_app/Provider/searchProvider.dart';
import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class NewArrivalScroll extends ConsumerStatefulWidget {
  const NewArrivalScroll({super.key, required this.sW,});

  final double sW;

  @override
  ConsumerState<NewArrivalScroll> createState() => _NewArrivalScrollState();
}

class _NewArrivalScrollState extends ConsumerState<NewArrivalScroll> {
  @override
  Widget build(BuildContext context) {
    List categories = ref.watch(categoriesProvider);

    return SizedBox(
      height: 800 * widget.sW,

      child: Column(
        children: [
          SizedBox(height: 6.5 * widget.sW,),

          Text(
            'New Arrival',
            style: GoogleFonts.tenorSans(
                fontSize: 32 * widget.sW,
                letterSpacing: 2.5
            ),
          ),

          SizedBox(
            width: 125 * widget.sW,
            height: 9.25 * widget.sW,
            child: Image.asset(
              'lib/Images/HomePage/Logo/Line.png',
              color: Colors.black,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 23 * widget.sW,),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12 * widget.sW),
            height: 80 * widget.sW,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i = 0; i < categories.length; ++i)...[
                  GestureDetector(
                    onTap: () {
                      if (categories[i][1]) return;

                      for(int i2 = 0; i2 < categories.length; ++i2){
                        categories[i2][1] = false;
                      }
                      categories[i][1] = true;

                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 * widget.sW),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            categories[i][0].toString(),
                            style: GoogleFonts.tenorSans(
                                color: categories[i][1] == true ? Color(0xFF212806) : Color(0xFF888888),
                                fontSize: 20 * widget.sW
                            ),
                          ),

                          Text(
                            '◆',
                            style: TextStyle(
                              color: categories[i][1] ? Color(0xFFDD8560) : Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),

          // SizedBox(height: widget.sW * 0.025,),

          Expanded(
            child: ItemShowByCategory(
              key: ValueKey(widget.key),
              category: getSelectedCategory(categories),
              sW: widget.sW,
            ),
          ),

          // SizedBox(height: 25 * widget.sW,),

          MaterialButton(
            onPressed: (){
              debugPrint(ref.read(searchKeywordsProvider).toString());
            },
            child: SizedBox(
              // padding: EdgeInsets.only(top: 50 * widget.sW),
              width: 165 * widget.sW,
              height: 48 * widget.sW,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Explore more',
                    style: GoogleFonts.tenorSans(
                      fontSize: 20 * widget.sW,
                      color: Colors.black,
                      fontWeight: FontWeight.w300
                    )
                  ),
                  Icon(Icons.arrow_forward,)
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  String getSelectedCategory(List categories){
    for (int i = 0; i < categories.length; ++i){
      if (categories[i][1]) return categories[i][0];
    }
    return "";
  }
}

class ItemShowByCategory extends ConsumerStatefulWidget {
  const ItemShowByCategory({super.key, required this.category, required this.sW});

  final String category;
  final double sW;

  @override
  ConsumerState<ItemShowByCategory> createState() => _ItemShowByCategoryState();
}

class _ItemShowByCategoryState extends ConsumerState<ItemShowByCategory> {
  @override
  Widget build(BuildContext context) {
    List<Product> catItemsList = listByCategory();
    catItemsList.shuffle();

    return SizedBox(
      height: 530 * widget.sW,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * widget.sW,),
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
                          imgIndexes: [catItemsList[index].imgCount - 1, catItemsList[index].imgCount],
                          padding: 165 * widget.sW * 0.01,
                        )
                    ),

                    Text(
                      (catItemsList[index].name.length < 44
                          ? catItemsList[index].name
                          : '${catItemsList[index].name.toString().substring(0, 41)}..'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                          fontSize: 14 * widget.sW,
                          color: Color(0xFF333333)
                      ),
                    ),

                    Text(
                      '${catItemsList[index].price} ${catItemsList[index].currency}',
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

  List<Product> listByCategory(){
    List<Product> itemList = ref.read(productCatalogProvider);

    if (widget.category == "All") return itemList;

    List<Product> catItemsList = [];

    for (int i = 0; i < itemList.length; ++i){
      if (itemList[i].category.last == widget.category){
        catItemsList.add(itemList[i]);
      }
    }

    return catItemsList;
  }
}