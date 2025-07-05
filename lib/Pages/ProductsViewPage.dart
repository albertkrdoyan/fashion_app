import 'package:fashion_app/Pages/MainPage.dart';
import 'package:fashion_app/Pages/MenuPage.dart';
import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Pages/ProductDetailsPage.dart';
import 'package:fashion_app/Provider/CatalogProvider.dart';
import 'package:fashion_app/Provider/NumberedPageIndicatorProvider.dart';
import 'package:fashion_app/Provider/searchProvider.dart';
import 'package:fashion_app/Utils/ItemShow.dart';
import 'package:fashion_app/Utils/NumberedPageIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsViewPage extends ConsumerWidget {
  const ProductsViewPage({super.key});
  static bool isProductsViewPageActive = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    isProductsViewPageActive = true;
    double sW = MediaQuery.sizeOf(context).width / 375;
    debugPrint('ProductsViewPage');

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          isProductsViewPageActive = false;
          debugPrint('bye $isProductsViewPageActive');
          ref.read(searchKeywordsProvider.notifier).clear();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 60 * sW,
          title: GestureDetector(
            onTap: () {
              isProductsViewPageActive = false;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Image.asset('lib/Images/HomePage/Logo/Logo.png')
          ),
          leading: Builder(
            builder: (context) => GestureDetector(
              child: Image.asset('lib/Images/HomePage/Logo/Menu.png'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const MenuPage();
                    },
                  )
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16 * sW),
              child: Image.asset('lib/Images/HomePage/Logo/Search.png',),
            ),
            Padding(
              padding: EdgeInsets.only(right: 23 * sW),
              child: Image.asset('lib/Images/HomePage/Logo/ShoppingBag.png'),
            )
          ],
        ),
        body: SafeArea(
          child: Consumer(
            builder: (_, ref, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final searchKeywords = ref.watch(searchKeywordsProvider);
                  debugPrint('LayoutBuilder');
          
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 17 * sW,),
          
                            const ShowInfoBar(),
          
                            // search keywords
                            if (searchKeywords.isNotEmpty)...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.5 * sW),
                                height: 52 * sW,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (int i = 0; i < searchKeywords.length; ++i)...[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30 * sW),
                                          border: Border.all(
                                            width: 1 * sW,
                                            color: const Color(0xFFDEDEDE)
                                          )
                                        ),
                                        margin: EdgeInsets.only(left: 2.5 * sW, right: 2.5 * sW, top: 8 * sW),
                                        padding: EdgeInsets.symmetric(horizontal: 15 * sW, vertical: 8 * sW),
                                        child: Row(
                                          children: [
                                            Text(
                                              searchKeywords[i][0],
                                              style: GoogleFonts.tenorSans(
                                                fontSize: 14 * sW
                                              ),
                                            ),
          
                                            SizedBox(width: 6 * sW,),
          
                                            GestureDetector(
                                              onTap: () {
                                                ref.read(searchKeywordsProvider.notifier).removeFromKeywords(searchKeywords[i][0]);
                                                ref.read(numberedPageIndicatorProvider.notifier).changeCurrentPage(0);
                                              },
                                              child: Icon(Icons.close, size: 18 * sW,)
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ],
          
                            SizedBox(height: 8 * sW,),
          
                            // show items
                            const BuildItemsShow(),
          
                            SizedBox(height: 50 * sW,),
          
                            // bottom part
                            const Spacer(),
                            const BottomInfo(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class BuildItemsShow extends ConsumerWidget{
  const BuildItemsShow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.of(context).size.width / 375;
    bool isGridView = ref.watch(gridViewProvider);
    bool isFiltered = ref.watch(filterProvider);

    debugPrint('BuildItemsShow');

    final List<Product> catalog = ref.read(productCatalogProvider);
    final searchKeywords = ref.read(searchKeywordsProvider);
    List<Product> list = [];

    if (ref.read(searchKeywordsProvider).isEmpty){
      list = catalog;
    }else{
      for (int i = 0; i < searchKeywords.length; ++i){
        if (searchKeywords[i][1]){
          list = ref.read(productCatalogProvider.notifier).filterByCategory(searchKeywords[i][0]);
          break;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listItemsCountProvider.notifier).update(list.length);

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300), // or any duration you like
        curve: Curves.easeInOut,               // or Curves.linear, etc.
      );
    });

    ref.read(numberedPageIndicatorProvider.notifier).setPagesCount((list.length ~/ 10) + (list.length % 10 != 0 ? 1 : 0));
    // ref.read(numberedPageIndicatorProvider.notifier).setPagesCount(15);

    final currentPage = ref.watch(numberedPageIndicatorProvider).currentPage;
    final int currentPageInfo = list.length - currentPage * 10, h = 305;
    final double height = (currentPageInfo > 8 ? 1500 : (currentPageInfo ~/ 2 + (currentPageInfo % 2 == 0 ? 0 : 1)) * h) * sW;

    return Column(
      children: [
        if(true)
          if (isGridView)...[
            Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 16.5 * sW, vertical: 8 * sW),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentPageInfo > 10 ? 10 : currentPageInfo,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.579
                ),
                itemBuilder: (BuildContext context, int index) {
                  int thisIndex = index + currentPage * 10;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: list[thisIndex]),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFE3E3E3),
                            width: 1 * sW
                        ),
                        borderRadius: BorderRadius.circular(2 * sW),
                        boxShadow: const [BoxShadow(color: Colors.white54, blurRadius: 2)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 219 * sW,
                            width: 165 * sW,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ItemShow(
                                  product: list[thisIndex],
                                  sW: sW,
                                  imgIndexes: [list[thisIndex].imgCount - 1, list[thisIndex].imgCount],
                                  padding: 165 * sW * 0.01,
                                ),

                                Container(
                                  margin: EdgeInsets.only(bottom: 6 * sW, right: 9 * sW),
                                  alignment: Alignment.bottomRight,
                                  child: const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Color(0xFFDD8560),
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0 * sW),
                            child: Text(
                              list[thisIndex].name,
                              style: GoogleFonts.tenorSans(
                                  fontSize: 12 * sW,
                                  color: Colors.black
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0 * sW),
                            child: Text(
                              '${list[thisIndex].price} ${list[thisIndex].currency}',
                              style: GoogleFonts.tenorSans(
                                  fontSize: 15 * sW,
                                  color: const Color(0xFFDD8560)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ]
          else...[
            GestureDetector(
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 16.5 * sW, vertical: 8 * sW),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentPageInfo > 10 ? 10 : currentPageInfo,
                  itemBuilder: (BuildContext context, int index) {
                    int thisIndex = index + currentPage * 10;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(product: list[thisIndex]),
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6 * sW),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFE3E3E3),
                              width: 1 * sW
                          ),
                          borderRadius: BorderRadius.circular(2 * sW),
                          boxShadow: const [BoxShadow(color: Colors.white54, blurRadius: 2)],
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 134 * sW,
                              width: 100 * sW,
                              child: ItemShow(
                                product: list[thisIndex],
                                sW: sW,
                                imgIndexes: [list[thisIndex].imgCount - 1, list[thisIndex].imgCount],
                                padding: 90 * sW * 0.01,
                              ),
                            ),

                            Container(
                              width: 230 * sW,
                              height: 134 * sW,
                              padding: EdgeInsets.symmetric(horizontal: 5 * sW),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        list[thisIndex].brand,
                                        softWrap: true,
                                        style: GoogleFonts.tenorSans(
                                            fontSize: 20 * sW,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),

                                      const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Color(0xFFDD8560),
                                      )
                                    ],
                                  ),

                                  Text(
                                    list[thisIndex].name,
                                    softWrap: true,
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 14 * sW,
                                        color: Colors.black
                                    ),
                                  ),

                                  Text(
                                    '${list[thisIndex].price} ${list[thisIndex].currency}',
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 18 * sW,
                                        color: const Color(0xFFDD8560)
                                    ),
                                  ),

                                  // sizes
                                  Row(
                                    children: [
                                      Text(
                                        'Size: ',
                                        style: GoogleFonts.tenorSans(
                                            fontSize: 14 * sW,
                                            color: const Color(0xFF555555)
                                        ),
                                      ),

                                      if (list[thisIndex].size.length == 1)...[
                                        Container(
                                          height: 28 * sW,
                                          width: 110 * sW,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8 * sW),
                                              border: Border.all(
                                                  width: 1 * sW,
                                                  color: const Color(0xFFE3E3E3)
                                              )
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              list[thisIndex].size[0],
                                              style: GoogleFonts.tenorSans(
                                                  fontSize: 16 * sW,
                                                  color: const Color(0xFF555555)
                                              ),
                                            ),
                                          ),
                                        )
                                      ]else...[
                                        for (int i = 0; i < list[thisIndex].size.length; ++i)...[
                                          Container(
                                            margin: EdgeInsets.only(right: 6 * sW),
                                            height: 28 * sW,
                                            width: 28 * sW,
                                            decoration: BoxDecoration(
                                              // borderRadius: BorderRadius.circular(8 * sW),
                                                border: Border.all(
                                                  width: 1 * sW,
                                                  color: const Color(0xFFE3E3E3),
                                                ),
                                                shape: BoxShape.circle
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                list[thisIndex].size[i],
                                                style: GoogleFonts.tenorSans(
                                                    fontSize: 10 * sW,
                                                    color: const Color(0xFF555555),
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                      ]
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],

        SizedBox(height: 55 * sW,),
        const NumberedPageIndicator(),
      ],
    );
  }
}

class ShowInfoBar extends ConsumerWidget {
  const ShowInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ShowInfoBar');
    double sW = MediaQuery.of(context).size.width / 375;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.5 * sW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${ref.watch(listItemsCountProvider)} Items',
            style: GoogleFonts.tenorSans(
                fontSize: 14 * sW,
                color: const Color(0xFF333333)
            ),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(gridViewProvider.notifier).change();
                },
                child: Container(
                  height: 35 * sW,
                  width: 35 * sW,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100
                  ),
                  child: Icon(
                    ref.watch(gridViewProvider) ? Icons.grid_view_outlined : Icons.view_agenda_outlined,
                    size: 20 * sW,
                    color: Colors.grey.shade600
                  ),
                ),
              ),
              SizedBox(width: 9 * sW,),
              GestureDetector(
                onTap: () {
                  ref.read(filterProvider.notifier).change();
                },
                child: Container(
                  height: 35 * sW,
                  width: 35 * sW,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100
                  ),
                  child: Icon(
                      Icons.filter_list_rounded,
                      size: 20 * sW,
                      color: ref.watch(filterProvider) ? const Color(0xFFDD8560) : Colors.grey.shade600
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

