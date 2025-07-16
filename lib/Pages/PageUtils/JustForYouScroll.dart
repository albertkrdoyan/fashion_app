import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Pages/ProductDetailsPage.dart';
import 'package:fashion_app/Provider/CatalogProvider.dart';
import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:fashion_app/Utils/pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/DrawPageIndicator.dart';

class JustForYouScroll extends ConsumerStatefulWidget {
  const JustForYouScroll({super.key, required this.sW});

  final double sW;

  @override
  ConsumerState<JustForYouScroll> createState() => _StateJustForYouScroll();
}
class _StateJustForYouScroll extends ConsumerState<JustForYouScroll>{
  final justForYouSectionController = PageController(viewportFraction: 0.68);

  @override
  void dispose() {
    justForYouSectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 531 * widget.sW,
      width: 375 * widget.sW,
      child: Column(
        children: [
          SizedBox(height: 45 * widget.sW,),

          Text(
            'JUST FOR YOU',
            style: GoogleFonts.tenorSans(
                color: Colors.black,
                letterSpacing: 10,
                fontSize: 20 * widget.sW
            ),
          ),

          const LinePattern(backColor: Colors.white, color: Color(0xFF222222)),

          SizedBox(height: 22 * widget.sW,),

          JustForYouSection(
            justForYouSectionController: justForYouSectionController,
            sW: widget.sW,
            count: 5,
          ),

          SizedBox(height: 17 * widget.sW,),

          DrawPageIndicator(controller: justForYouSectionController, size: 6.5 * widget.sW, count: 5,),

          // SizedBox(height: screenHeight * 0.04,),
        ],
      ),
    );
  }
}

class JustForYouSection extends ConsumerWidget{
  const JustForYouSection({super.key, required this.justForYouSectionController, required this.sW, required this.count});

  final PageController justForYouSectionController;
  final double sW;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> items = ref.watch(productCatalogProvider);

    if (items.isEmpty) {
      return const SizedBox.shrink(); // or some "No items found" message
    }

    List<Product> newList = getRandomElements(count, items);

    return SizedBox(
      height: 390 * sW,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: justForYouSectionController,
        itemCount: count,
        padding: EdgeInsets.symmetric(horizontal: 16 * sW),
        itemBuilder: (context, index) => 
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: newList[index]),
              ));
            },
            child: SizedBox(
              width: 255 * sW,
              key: ValueKey(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    key: ValueKey(index),
                    width: 255 * sW,
                    height: 280 * sW,
                    child: ItemShow(
                      key: ValueKey(index),
                      product: newList[index],
                      sW: sW,
                      imgIndexes: List<int>.generate(
                        newList[index].imgCount - 2, (index_) => index_ + 1,
                      ),
                      padding: 255 * sW * 0.01,
                    ),
                  ),
            
                  Text(
                    (newList[index].name.length < 44
                        ? newList[index].name
                        : '${newList[index].name.substring(0, 41)}..'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenorSans(
                        fontSize: 18 * sW,
                        color: const Color(0xFF333333)
                    ),
                  ),
            
                  Text(
                    '${newList[index].price} ${newList[index].currency}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenorSans(
                        fontSize: 22 * sW,
                        color: const Color(0xFFDD8560),
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
                    ),
          ),
        separatorBuilder: (context, index) => SizedBox(width: 11 * sW,),
      ),
    );
  }

  List<Product> getRandomElements(int count, List<Product> items) {
    List indices = List.generate(items.length, (index) => index);
    indices.shuffle();

    return List<Product>.generate(count, (index) => items[indices[index]],);
  }
}