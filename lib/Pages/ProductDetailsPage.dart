import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Models/svgImages.dart';
import 'package:fashion_app/Pages/MainPage.dart';
import 'package:fashion_app/Pages/PageUtils/CartPageLoader.dart';
import 'package:fashion_app/Pages/PageUtils/ProductSizeSelection.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:fashion_app/Utils/DrawPageIndicator.dart';
import 'package:fashion_app/Utils/catalogImagesPath.dart';
import 'package:fashion_app/Utils/svgIconButtonWithStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends ConsumerWidget {
  ProductDetailsPage({super.key, required this.product});

  final Product product;

  final imagesController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.sizeOf(context).width / 375;

    debugPrint('_ProductDetailsPageState');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60 * sW,
        title: SvgPicture.asset('lib/Images/HomePage/Logo/Logo.svg'),
        actions: const [
          CartPageLoader()
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: MaterialButton(
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(product, 1, ProductSizeSelection.selectedSizeO);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The item has been added to your cart.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          // height: 86 * sH,
          padding: EdgeInsets.symmetric(vertical: 15 * sW),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart_sharp, color: Colors.white, size: 28 * sW,),
              SizedBox(width: 10 * sW,),
              Text(
                " ADD TO CART",
                style: GoogleFonts.tenorSans(
                  color: Colors.white,
                  fontSize: 14 * sW,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // product images section with indicator
                      SizedBox(
                        width: 375 * sW,
                        height: 510 * sW,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //images
                            Container(
                              margin: EdgeInsets.only(top: 20 * sW,),
                              width: 343 * sW,
                              height: 460 * sW,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ImageShow(imagesController: imagesController, product: product),

                                  GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ImageViewFullScreen(
                                        product: product,
                                        initialIndex: imagesController.page,
                                      ),
                                    )),
                                    child: SvgIconButtonWithStyle(
                                      color: Colors.black.withAlpha(165),
                                      svgPath: zoomInSVG,
                                    )
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10 * sW,),
                            // indicator
                            DrawPageIndicator(controller: imagesController, size: 6.5 * sW, count: product.imgCount, selectedItemColor: Colors.grey,),

                            SizedBox(height: 10 * sW,),
                          ],
                        ),
                      ),

                      // name brand price add
                      Container(
                        padding: EdgeInsets.only(left: 16 * sW, right: 16 * sW, top: 6 * sW),
                        height: 140 * sW,
                        width: 375 * sW,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brand,
                              style: GoogleFonts.tenorSans(
                                fontSize: 16 * sW,
                                letterSpacing: 4 * sW
                              ),
                            ),

                            Text(
                              product.name,
                              style: GoogleFonts.tenorSans(
                                fontSize: 16 * sW,
                                color: const Color(0xFF555555)
                              ),
                            ),

                            Text(
                              '${product.price} ${product.currency}',
                              style: GoogleFonts.tenorSans(
                                fontSize: 18 * sW,
                                color: const Color(0xFFDD8560)
                              ),
                            ),

                            SizedBox(height: 10 * sW,),

                            ProductSizeSelection(
                              product: product,
                            )
                          ],
                        ),
                      ),

                      // a black line
                      Container(
                        height: 2 * sW,
                        width: (375 - 32) * sW,
                        padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                        margin: EdgeInsets.symmetric(vertical: 25 * sW),
                        color: Colors.black,
                      ),

                      // info
                      if (product.outerShell.isNotEmpty || product.lining.isNotEmpty)...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'MATERIALS'.toUpperCase(),
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: Colors.black,
                              letterSpacing: 4 * sW
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                          child: Column(
                            children: [
                              if (product.outerShell.isNotEmpty)...[
                                SizedBox(height: 8 * sW,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'OUTER SHELL'.toUpperCase(),
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 14 * sW,
                                        color: Colors.black,
                                        letterSpacing: 1 * sW
                                    ),
                                  ),
                                ),
                                for (int i = 0; i < product.outerShell.length; ++i)...[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.outerShell[i],
                                      style: GoogleFonts.tenorSans(
                                        fontSize: 14 * sW,
                                        color: const Color(0xFF555555),
                                      ),
                                    ),
                                  ),
                                ],
                              ],

                              if (product.lining.isNotEmpty)...[
                                SizedBox(height: 8 * sW,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'LINING'.toUpperCase(),
                                    style: GoogleFonts.tenorSans(
                                        fontSize: 14 * sW,
                                        color: Colors.black,
                                        letterSpacing: 1 * sW
                                    ),
                                  ),
                                ),
                                for (int i = 0; i < product.lining.length; ++i)...[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.lining[i],
                                      style: GoogleFonts.tenorSans(
                                        fontSize: 14 * sW,
                                        color: const Color(0xFF555555),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        )
                      ],

                      if(product.description.isNotEmpty)...[
                        SizedBox(height: 16 * sW,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Description'.toUpperCase(),
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: Colors.black,
                              letterSpacing: 4 * sW
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.description,
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],

                      if(product.care.isNotEmpty)...[
                        SizedBox(height: 16 * sW,),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CARE',
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: Colors.black,
                              letterSpacing: 4 * sW
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.care,
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),

                        SizedBox(height: 13 * sW,),

                        for (int i = 0; i < product.info.length; ++i)...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20 * sW,
                                  width: 20 * sW,
                                  child: SvgPicture.string(careSGVs[product.info[i].toUpperCase()]!),
                                ),
                                SizedBox(width: 12.5 * sW,),
                                Expanded(
                                  child: Text(
                                    product.info[i],
                                    style: GoogleFonts.tenorSans(
                                      fontSize: 14 * sW,
                                      color: const Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],

                      if(product.origin.isNotEmpty)...[
                        SizedBox(height: 16 * sW,),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ORIGIN',
                            style: GoogleFonts.tenorSans(
                                fontSize: 14 * sW,
                                color: Colors.black,
                                letterSpacing: 4 * sW
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * sW, vertical: 6.25 * sW),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.origin,
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 75 * sW,),

                      // bottom info
                      const Spacer(),
                      const BottomInfo(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageShow extends StatelessWidget {
  const ImageShow({super.key, required this.imagesController, required this.product});

  final PageController imagesController;
  final Product product;

  @override
  Widget build(BuildContext context) {
    debugPrint('_ImageShowState');

    return PageView(
      controller: imagesController,
      children: [
        for (int i = 0; i < product.imgCount; ++i)...[
          Image.network(
            getUrlPath('${product.location}${product.extension}${formatNumber(i + 1)}.jpg'),
            fit: BoxFit.cover,
          )
        ]
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

class ImageViewFullScreen extends StatefulWidget {
  const ImageViewFullScreen({
    super.key,
    required this.product,
    required this.initialIndex
  });

  final Product product;
  final num? initialIndex;

  @override
  State<ImageViewFullScreen> createState() => _ImageViewFullScreenState();
}

class _ImageViewFullScreenState extends State<ImageViewFullScreen> {
  late PageController imagesController;
  int currentPage = 0;
  double verticalDrag = 0;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    imagesController = PageController(initialPage: widget.initialIndex?.toInt() ?? 0);
    currentPage = widget.initialIndex?.toInt() ?? 0;
  }

  @override
  void dispose() {
    imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width / 375;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              verticalDrag += details.delta.dy;
              isDragging = true;
            });
          },
          onVerticalDragEnd: (details) {
            if (verticalDrag.abs() > 130) {
              Navigator.pop(context);
            } else {
              setState(() {
                verticalDrag = 0;
                isDragging = false;
              });
            }
          },
          child: Stack(
            children: [
              // Animated transformation
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transformAlignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(0.0, verticalDrag)
                    ..scale(1.0 - (verticalDrag / 500).clamp(0.0, 0.2)),
                  curve: Curves.easeOut,
                  child: Opacity(
                    opacity: (1.0 - verticalDrag.abs() / 300).clamp(0.0, 1.0),
                    child: SizedBox(
                      width: 375 * sW,
                      height: (375 * 16 / 9) * sW,
                      child: PageView.builder(
                        controller: imagesController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemCount: widget.product.imgCount,
                        itemBuilder: (context, index) {
                          return Image.network(
                            getUrlPath('${widget.product.location}${widget.product.extension}${formatNumber(index + 1)}.jpg'),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Close button (optional)
              if (!isDragging)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15 * sW, top: 8 * sW),
                        child: SvgIconButtonWithStyle(
                          color: Colors.white.withAlpha(128),
                          svgPath: zoomOutSVG,
                        ),
                      ),
                    ),
                  ],
                ),

              // Page index at bottom center
              if (!isDragging)
                Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20 * sW),
                  padding: EdgeInsets.symmetric(horizontal: 12 * sW, vertical: 4 * sW),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128),
                    borderRadius: BorderRadius.circular(8 * sW),
                  ),
                  child: Text(
                    '${currentPage + 1} / ${widget.product.imgCount}',
                    style: GoogleFonts.tenorSans(
                      fontSize: 14 * sW,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatNumber(int number) {
    return number.toString().padLeft(3, '0');
  }
}
