import 'package:fashion_app/Pages/ProductDetailsPage.dart';
import 'package:fashion_app/Pages/ProductsViewPage.dart';
import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Provider/CatalogProvider.dart';
import 'package:fashion_app/Provider/searchProvider.dart';
import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:fashion_app/Utils/pattern.dart';
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
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<List<String>> categories = ref.watch(productCategoriesProvider);

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

          const LinePattern(backColor: Colors.white, color: Color(0xFF222222)),

          SizedBox(height: 23 * widget.sW,),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12 * widget.sW),
            height: 80 * widget.sW,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i = 0; i < (categories.length > 4 ? 4 : categories.length); ++i)...[
                  GestureDetector(
                    onTap: () {
                      if (i == selectedCategoryIndex) return;
                      selectedCategoryIndex = i;

                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 * widget.sW),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${categories[i][0][0]}/${categories[i][2]}',
                            style: GoogleFonts.tenorSans(
                                color: i == selectedCategoryIndex ? const Color(0xFF212806) : const Color(0xFF888888),
                                fontSize: 20 * widget.sW
                            ),
                          ),

                          Text(
                            '◆',
                            style: TextStyle(
                              color: i == selectedCategoryIndex ? const Color(0xFFDD8560) : Colors.transparent,
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

          if (categories.isNotEmpty)...[
            Expanded(
              child: ItemShowByCategory(
                key: ValueKey(widget.key),
                category: categories[selectedCategoryIndex],
                sW: widget.sW,
              ),
            ),
          ],

          MaterialButton(
            onPressed: (){
              final searchString = "${categories[selectedCategoryIndex][0]} / ${categories[selectedCategoryIndex][1]} / ${categories[selectedCategoryIndex][2]}";
              ref.read(searchKeywordsProvider.notifier).addToKeywords([searchString, true]);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductsViewPage(),),
              );
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
                  const Icon(Icons.arrow_forward,)
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}

class ItemShowByCategory extends ConsumerWidget {
  const ItemShowByCategory({super.key, required this.category, required this.sW});

  final List<String> category;
  final double sW;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> catItemsList = listByCategory(ref);
    catItemsList.shuffle();

    return SizedBox(
      height: 530 * sW,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * sW,),
        child: MasonryGridView.count(
          key: ValueKey(key),
          itemCount: catItemsList.length > 4 ? 4 : catItemsList.length,
          crossAxisCount: 2,
          crossAxisSpacing: 13 * sW,
          mainAxisSpacing: 11 * sW,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: catItemsList[index]),
                ));
              },
              child: SizedBox(
                  key: ValueKey(index),
                  height: 265 * sW,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          key: ValueKey(index),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                                color: const Color(0xFF888888).withAlpha(75),
                                width: 1
                            ),
                          ),
                          height: 200 * sW,
                          width: 165 * sW,
                          child: ItemShow(
                            key: ValueKey(index),
                            product: catItemsList[index],
                            sW: sW,
                            imgIndexes: [catItemsList[index].imgCount - 1, catItemsList[index].imgCount],
                            padding: 165 * sW * 0.01,
                          )
                      ),

                      Text(
                        (catItemsList[index].name.length < 44
                            ? catItemsList[index].name
                            : '${catItemsList[index].name.toString().substring(0, 41)}..'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tenorSans(
                            fontSize: 14 * sW,
                            color: const Color(0xFF333333)
                        ),
                      ),

                      Text(
                        '${catItemsList[index].price} ${catItemsList[index].currency}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tenorSans(
                            fontSize: 16 * sW,
                            color: const Color(0xFFDD8560)
                        ),
                      )
                    ],
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  List<Product> listByCategory(WidgetRef ref){
    List<Product> itemList = ref.read(productCatalogProvider);

    if (category[0] == "All") return itemList;

    List<Product> catItemsList = [];

    for (int i = 0; i < itemList.length; ++i){
      if (areSame(itemList[i].category, category)){
        catItemsList.add(itemList[i]);
      }
    }

    return catItemsList;
  }

  bool areSame(List<String> l1, List<String> l2){
    if (l1.length != l2.length) return false;

    for (int i = 0; i < l1.length; ++i){
      if (l1[i] != l2[i]) return false;
    }

    return true;
  }
}