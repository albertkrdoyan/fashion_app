import 'dart:async';
import 'package:fashion_app/Pages/MenuPage.dart';
import 'package:fashion_app/Pages/PageUtils/CartPageLoader.dart';
import 'package:fashion_app/Pages/PageUtils/JustForYouScroll.dart';
import 'package:fashion_app/Pages/PageUtils/NewArrivalScroll.dart';
import 'package:fashion_app/Pages/ProductsViewPage.dart';
import 'package:fashion_app/Provider/CatalogProvider.dart';
import 'package:fashion_app/Utils/DrawPageIndicator.dart';
import 'package:fashion_app/Utils/TextOnImage.dart';
import 'package:fashion_app/Utils/pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Provider/jsonProvider.dart';

class MainPage extends ConsumerStatefulWidget{
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}
class _MainPageState extends ConsumerState<MainPage> {
  final mainPageImagesController = PageController();
  static const _autoScrollDuration = 15;
  int _currentPage = 0;
  Timer? _timer;

  MenuPage? menuPage;
  GlobalKey<MenuPageState> menuPageKey = GlobalKey<MenuPageState>();

  @override
  void dispose() {
    mainPageImagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;

    return ref.watch(jsonDataProvider).when(
      data: (data) {
        final List dataList = data['mainPage'];
        final List trendsList = data['trends'];
        final List openFashionList = data['openFashion'];
        final List followUsList = data['followUs'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(productCatalogProvider.notifier).updateList(data['catalog']);
          ref.read(productCategoriesProvider.notifier).update(ref.read(productCatalogProvider));
        });

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFE7EAEF),
            centerTitle: true,
            toolbarHeight: 60 * sW,
            // title: Image.asset('lib/Images/HomePage/Logo/Logo.png'),
            title: SvgPicture.asset('lib/Images/HomePage/Logo/Logo.svg'),
            leading: Builder(
              builder: (context) => GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15 * sW),
                  child: SvgPicture.asset('lib/Images/HomePage/Logo/Menu.svg'),
                ),
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
                child: SvgPicture.asset('lib/Images/HomePage/Logo/Search.svg', height: 25 * sW, width: 20 * sW,)
              ),
              // SizedBox(width: screenWidth * 0.04,),
              const CartPageLoader(),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // poster
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // poster
                      GestureDetector(
                        onPanDown: (_) => _pauseAutoSlide(dataList.length, _autoScrollDuration),
                        child: SizedBox(
                          height: 600 * sW,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            controller: mainPageImagesController,
                            onPageChanged: (index) => _currentPage = index,

                            children: [
                              for (int i = 0; i < dataList.length; ++i)...[
                                TextOnScreen(
                                  imgPath: dataList[i]['img_path'],
                                  textOnImage: dataList[i]['text'],
                                  sW: sW,
                                )
                              ]
                            ],
                          ),
                        ),
                      ),

                      // button & indicator
                      Column(
                        children: [
                          MaterialButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProductsViewPage(),),
                              );
                            },
                            color: Colors.black.withAlpha(125),
                            height: 40 * sW,
                            minWidth: 253 * sW,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30 * sW)
                            ),
                            child: Text(
                                'EXPLORE COLLECTION',
                                style: GoogleFonts.tenorSans(
                                    fontSize: 16 * sW,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300
                                )
                            ),
                          ),

                          SizedBox(height: 14 * sW,),

                          DrawPageIndicator(controller: mainPageImagesController, size: 6.5 * sW, count: 3,),

                          SizedBox(height: 18 * sW,),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 27 * sW,),

                  // new arrival
                  NewArrivalScroll(key: ValueKey(widget.key), sW: sW,),

                  SizedBox(height: 37 * sW,),

                  SvgPicture.asset('lib/Images/HomePage/Main/Brand.svg'),

                  SizedBox(height: 47 * sW,),

                  // collection
                  Stack(
                    // fit: StackFit.,
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset('lib/Images/HomePage/Main/AutumnCollection.png'),

                      Text(
                        'COLLECTIONS',
                        style: GoogleFonts.tenorSans(
                            color: Colors.black,
                            letterSpacing: 10,
                            fontSize: 20 * sW
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 32 * sW,),

                  // video
                  SizedBox(
                    width: 375 * sW,
                    height: 176 * sW,
                    child: Image.asset(
                      'lib/Images/HomePage/Main/Video.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 49 * sW,),

                  // just for U
                  JustForYouScroll(sW: sW,),

                  SizedBox(height: 38 * sW,),

                  // trending
                  SizedBox(
                    width: 375 * sW,
                    height: 140 * sW,
                    child: Column(
                      children: [
                        Text(
                          '@TRENDING',
                          style: GoogleFonts.tenorSans(
                              fontSize: 20 * sW,
                              letterSpacing: 4 * sW,
                              height: 1.5 * sW
                          ),
                        ),

                        Container(
                          // color: Colors.blue,
                          padding: EdgeInsets.only(left: 16 * sW),
                          width: 375 * sW,
                          height: 75 * sW,
                          child: MasonryGridView.custom(
                            crossAxisSpacing: 8 * sW,
                            scrollDirection: Axis.horizontal,
                            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2
                            ),
                            childrenDelegate: SliverChildListDelegate([
                              for (int i = 0; i < trendsList.length; ++i)...[
                                Container(
                                  // color: Colors.yellow,
                                  padding: EdgeInsets.symmetric(horizontal: 10 * sW),
                                  child: Center(
                                    child: Text(
                                      '#${trendsList[i]['name']}',
                                      style: GoogleFonts.tenorSans(
                                          fontSize: 16 * sW
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            ])
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 22 * sW,),

                  // open fashion
                  Container(
                    color: const Color(0xFFF2F2F2),
                    width: 375 * sW,
                    height: 450 * sW,
                    child: Column(
                      children: [
                        SizedBox(height: 27.56 * sW,),

                        SizedBox(
                          height: 40 * sW,
                          width: 98 * sW,
                          child: SvgPicture.asset(
                            'lib/Images/HomePage/Logo/Logo.svg',
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: 16 * sW,),

                        SizedBox(
                          height: 66 * sW,
                          width: 285 * sW,
                          child: Text(
                            'Making a luxurious lifestyle accessible\nfor a generous group of women is our\ndaily drive.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tenorSans(
                                fontSize: 14 * sW,
                                letterSpacing: 1 * sW,
                                color: const Color(0xFF555555)
                            ),
                          ),
                        ),

                        SizedBox(height: 5 * sW,),

                        const LinePattern(backColor: Colors.white, color: Color(0xFF222222)),

                        SizedBox(height: 13.6 * sW,),

                        SizedBox(
                          width: 375 * sW,
                          height: 180 * sW,
                          child: MasonryGridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: openFashionList.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) => SizedBox(
                              height: 90 * sW,
                              width: 165 * sW,
                              child: Column(
                                children: [
                                  Image.asset(
                                    openFashionList[index]['img'],
                                    fit: BoxFit.fitWidth,
                                    height: 48 * sW,
                                    width: 52 * sW,
                                  ),

                                  Text(
                                    openFashionList[index]['text'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 13 * sW,
                                        color: const Color(0xFF555555)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 33 * sW,),

                        SizedBox(
                          height: 40 * sW,
                          width: 67 * sW,
                          child: Image.asset(
                            'lib/Images/OpenFashionImages/pattern.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 17 * sW,),

                  // follow us
                  SizedBox(
                    height: 460 * sW,
                    width: 375 * sW,
                    child: Column(
                      children: [
                        SizedBox(height: 16 * sW,),

                        // follow us text
                        SizedBox(
                          width: 150 * sW,
                          height: 40 * sW,
                          child: Center(
                            child: Text(
                              'FOLLOW US',
                              style: GoogleFonts.tenorSans(
                                  fontSize: 18 *  sW,
                                  letterSpacing: 3 * sW
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 2 * sW,),

                        // insta logo
                        SizedBox(
                          height: 24 * sW,
                          width: 24 * sW,
                          child: Image.asset(
                            'lib/Images/FollowUsImages/Instagram.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: 18 * sW,),

                        // instas
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.5 * sW),
                          height: 343 * sW,
                          width: 375 * sW,
                          child: MasonryGridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: followUsList.length,
                            crossAxisSpacing: 14 * sW,
                            mainAxisSpacing: 15 * sW,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) => SizedBox(
                                height: 164 * sW,
                                width: 164 * sW,
                                child: Stack(
                                  // alignment: Alignment.bottomCenter,
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      followUsList[index]['img'],
                                      fit: BoxFit.cover,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withAlpha(0),
                                                Colors.black.withAlpha(128),
                                                Colors.black.withAlpha(255)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: const [0.65, 0.85, 1]
                                          )
                                      ),
                                    ),

                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.only(left: 9 * sW, bottom: 12 * sW),
                                      child: Text(
                                        '@${followUsList[index]['username']}',
                                        style: GoogleFonts.tenorSans(
                                            color: Colors.white,
                                            // color: Colors.black,
                                            fontSize: 16 * sW,
                                            letterSpacing: 1 * sW
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 18 * sW,),

                  // bottom
                  const BottomInfo()
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }

  void _setTimerToMainPage(int count, int duration){
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: duration), (timer) {
        if (mainPageImagesController.hasClients) {
          _currentPage++;

          if (_currentPage >= count) _currentPage = 0;

          mainPageImagesController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    );
  }

  void _pauseAutoSlide(int count, int duration) {
    _timer?.cancel();

    // Resume after a delay (optional)
    Future.delayed(Duration(seconds: duration ~/ 5), () {
      _setTimerToMainPage(count, duration);
    });
  }
}

class BottomInfo extends StatelessWidget {
  const BottomInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;

    return SizedBox(
      height: 340 * sW,
      width: 375 * sW,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // info
          SizedBox(
            height: 295 * sW,
            width: 375 * sW,
            child: Column(
              children: [
                SizedBox(height: 23.78 * sW,),

                SizedBox(
                  width: 162 * sW,
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
                      )
                    ],
                  ),
                ),

                SizedBox(height: 24 * sW,),

                const LinePattern(backColor: Colors.white, color: Color(0xFF222222)),

                SizedBox(height: 15.73 * sW,),

                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      'support@openui.design\n+60 825 876\n08:00 - 22:00 - Everyday',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                          fontSize: 18 * sW,
                          letterSpacing: 0,
                          color: const Color(0xFF333333),
                          height: 1.5 * sW
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 18.73 * sW,),

                const LinePattern(backColor: Colors.white, color: Color(0xFF222222)),

                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'About',
                        style: GoogleFonts.tenorSans(
                          fontSize: 16 * sW,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                      ),

                      Text(
                        'Contact',
                        style: GoogleFonts.tenorSans(
                          fontSize: 16 * sW,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                      ),

                      Text(
                        'Blog',
                        style: GoogleFonts.tenorSans(
                          fontSize: 16 * sW,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // copyright
          Container(
            height: 45 * sW,
            width: 375 * sW,
            color: const Color(0xFFC4C4C4),
            child: Center(
              child: Text(
                'Copyright© OpenUI All Rights Reserved.',
                style: GoogleFonts.tenorSans(
                    fontSize: 12 * sW,
                    letterSpacing: 0,
                    color: const Color(0xFF555555)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
