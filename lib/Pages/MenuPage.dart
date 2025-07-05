import 'package:fashion_app/Pages/ProductsViewPage.dart';
import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Provider/NumberedPageIndicatorProvider.dart';
import 'package:fashion_app/Provider/searchProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  int currentMenuIndex = 0;
  final List wList = [
    'WOMEN',
    'MAN',
    'KIDS',
    'null'
  ];

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 640;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // close menu button
            Container(
              padding: EdgeInsets.only(left: 16 * sW, top: 10 * sH),
              alignment: Alignment.centerLeft,
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {Navigator.pop(context);},
                  child: Icon(Icons.close,size: 24 * sW,),
                ),
              ),
            ),

            // main categories layer
            Padding(
              padding: EdgeInsets.only(top: 20 * sH, left: 18 * sW, right: 17 * sW),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < wList.length; ++i)...[
                    GestureDetector(
                      onTap: () {
                        if (i == 3 || currentMenuIndex == i) return;
                        currentMenuIndex = i;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Text(
                            wList[i],
                            style: GoogleFonts.tenorSans(
                              color: i == 3 ? Colors.transparent : const Color(0xFF000000),
                              fontSize: 14 * sW,
                              letterSpacing: 3 * sW
                            ),
                          ),
                          SizedBox(height: (currentMenuIndex == i ? 4 : 5) * sH,),
                          Container(
                            width: 85 * sW,
                            height: (currentMenuIndex == i ? 3 : 1) * sH,
                            color: currentMenuIndex == i ? const Color(0xFFDD8560) : const Color(0xFF888888),
                          ),
                          if(currentMenuIndex != i)...[
                            SizedBox(height: 1 * sH,),
                          ]
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),

            DrawMenu(currentMenu: wList[currentMenuIndex]),
          ],
        ),
      ),
    );
  }
}

class DrawMenu extends ConsumerStatefulWidget {
  const DrawMenu({super.key, required this.currentMenu});
  final String currentMenu;

  @override
  ConsumerState<DrawMenu> createState() => _DrawMenuState();
}

class _DrawMenuState extends ConsumerState<DrawMenu> {
  List<bool> isExpandedList = [];
  late final Map<String, List<String>> subCategories;
  late final List<String> subCatNames;

  @override
  void initState() {
    super.initState();
    if (!Product.categories.containsKey(widget.currentMenu)) return;

    subCategories = Product.categories[widget.currentMenu]!;
    subCatNames = subCategories.keys.toList();
    isExpandedList = List<bool>.generate(subCatNames.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 640;

    final style = GoogleFonts.tenorSans(
        fontSize: 16 * sW,
        color: const Color(0xFF333333)
    );

    debugPrint(subCatNames.toString());

    if (!Product.categories.containsKey(widget.currentMenu)) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 18 * sW, right: 18 * sW, top: 20 * sH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                title: Text("No Items", style: style,),
              ),

              const Info()
            ],
          ),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 18 * sW, right: 18 * sW, top: 20 * sH),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    children: [
                      for (int i = 0; i < subCategories.length; ++i)...[
                        ExpansionTile(
                          trailing: AnimatedRotation(
                            turns: isExpandedList[i] ? 0.5 : 0.0, // 0.5 = 180 degrees
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.expand_more,
                              color: const Color(0xFF555555),
                              size: 24 * sW,
                            ),
                          ),
                          onExpansionChanged: (bool value) {
                            setState(() {
                              isExpandedList[i] = value;
                            });
                          },
                          title: Text(subCatNames[i], style: style,),
                          childrenPadding: EdgeInsets.only(left: 18 * sW),
                          children: [
                            SubMenuDraw(
                                currentMenu: widget.currentMenu,
                                subCatName: subCatNames[i],
                                subCategoriesMenu: 'All',
                                style: style,
                                sH: sH
                            ),

                            for (int j = 0; j < subCategories[subCatNames[i]]!.length; ++j)...[
                              SubMenuDraw(
                                currentMenu: widget.currentMenu,
                                subCatName: subCatNames[i],
                                subCategoriesMenu: subCategories[subCatNames[i]]![j],
                                style: style,
                                sH: sH,
                              )
                            ]
                          ],
                        )
                      ],
                    ],
                  ),
                )
              ),

              const Info()
            ],
          ),
        ),
      ),
    );
  }
}

class SubMenuDraw extends ConsumerWidget {
  const SubMenuDraw ({super.key, required this.currentMenu, required this.subCatName, required this.subCategoriesMenu, required this.style, required this.sH});
  final String currentMenu, subCategoriesMenu, subCatName;
  final TextStyle style;
  final double sH;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: InkWell(
        onTap: () {
          String cat = "$currentMenu / $subCatName / $subCategoriesMenu";
          ref.read(searchKeywordsProvider.notifier).addToKeywords([cat, true]);
          Navigator.pop(context);
          debugPrint(ProductsViewPage.isProductsViewPageActive.toString());
          if (!ProductsViewPage.isProductsViewPageActive){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProductsViewPage(),),
            );
          }
          else{
            ref.read(numberedPageIndicatorProvider.notifier).changeCurrentPage(0);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5 * sH),
          child: Text(
            subCategoriesMenu,
            style: style,
          ),
        ),
      ),
    );
  }
}


class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 640;

    return // info
      Column(
        children: [
          Container(
            height: 1 * sW,
            color: const Color(0xFF555555),
          ),

          Padding(
            padding: EdgeInsets.only(left: 18 * sW, top: 25 * sH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.phone,
                  size: 24 * sW,
                ),

                Text(
                  '   +(000) 00-00-00',
                  style: GoogleFonts.tenorSans(
                      fontSize: 16 * sW,
                      color: const Color(0xFF555555)
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 18 * sW, top: 15 * sH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 24 * sW,
                ),

                Text(
                  '   Store location',
                  style: GoogleFonts.tenorSans(
                      fontSize: 16 * sW,
                      color: const Color(0xFF555555)
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 27 * sH,),

          SizedBox(
            width: 125 * sW,
            height: 9.25 * sW,
            child: Image.asset(
              'lib/Images/HomePage/Logo/Line.png',
              color: Colors.black,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 24 * sH,),

          SizedBox(
            width: 142 * sW,
            height: 24 * sW,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 24 * sW,
                  width: 24 * sW,
                  child: Image.asset(
                    'lib/Images/Bottom/InstagramDark.png',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  height: 24 * sW,
                  width: 24 * sW,
                  child: Image.asset(
                    'lib/Images/Bottom/TwitterDark.png',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  height: 24 * sW,
                  width: 24 * sW,
                  child: Image.asset(
                    'lib/Images/Bottom/YouTubeDark.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
