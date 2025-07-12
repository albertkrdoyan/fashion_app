
import 'package:fashion_app/Pages/PageUtils/CheckoutPage.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:fashion_app/Utils/catalogImagesPath.dart';
import 'package:fashion_app/Utils/pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    final cartList = ref.read(cartProvider);
    final cartListNotifier = ref.read(cartProvider.notifier);

    debugPrint('CartPage');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60 * sW,
        title: SvgPicture.asset('lib/Images/HomePage/Logo/Logo.svg'),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 86 * sH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (cartList.isNotEmpty)...[
                Consumer(
                  builder: (_, ref, _) {
                    ref.watch(cartProvider);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * sW),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: GoogleFonts.tenorSans(
                              color: Colors.black,
                              fontSize: 20 * sW,
                              letterSpacing: 2 * sW
                            ),
                          ),

                          Text(
                            '${cartListNotifier.getTotalPrice()} ${cartList[0].product.currency}',
                            style: GoogleFonts.tenorSans(
                              color: const Color(0xFFDD8560),
                              fontSize: 20 * sW,
                              letterSpacing: 2 * sW
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ]else...[
                const SizedBox(height: 1,)
              ],

              MaterialButton(
                onPressed: () {
                  debugPrint('Tap');
                  cartList.isEmpty ? {
                    Navigator.of(context).pop(),
                  }
                  : {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckoutPage(),))
                  };
                },
                height: 56 * sH,
                minWidth: 375 * sW,
                color: Colors.black,
                child: cartList.isEmpty
                    ? Text(
                        'You have nothing in your cart.',
                        style: GoogleFonts.tenorSans(
                          color: Colors.white,
                          fontSize: 16 * sW,
                        ),
                      )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/Images/HomePage/Logo/ShoppingBagR.svg',
                          width: 28 * sW,
                          height: 28 * sH,
                        ),
                        SizedBox(width: 20 * sW),
                        Text(
                          'CHECKOUT',
                          style: GoogleFonts.tenorSans(
                            color: Colors.white,
                            fontSize: 16 * sW,
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 33 * sH),

                Text(
                  'CHECKOUT',
                  style: GoogleFonts.tenorSans(
                    color: Colors.black,
                    fontSize: 18 * sW,
                    letterSpacing: 4 * sW,
                  ),
                ),
                const LinePattern(
                  backColor: Colors.white,
                  color: Color(0xFF222222),
                ),

                SizedBox(height: 18 * sH),

                for (int i = 0; i < cartList.length; ++i) ...[
                  Container(
                    height: 135 * sH,
                    width: 343 * sW,
                    margin: EdgeInsets.symmetric(
                      vertical: 5 * sH,
                      horizontal: 16 * sW,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Image.asset(
                        //   cartList[i].product.path,
                        //   width: 100 * sW,
                        //   height: 135 * sH,
                        //   fit: BoxFit.cover,
                        // ),

                        Image.network(
                          getUrlPath(cartList[i].product.path),
                          width: 100 * sW,
                          height: 135 * sH,
                          fit: BoxFit.cover,
                        ),

                        SizedBox(width: 11 * sW),

                        SizedBox(
                          width: 230 * sW,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cartList[i].product.brand,
                                    style: GoogleFonts.tenorSans(
                                      fontSize: 14 * sW,
                                      letterSpacing: 2 * sW,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      cartListNotifier.remove(i);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.remove_shopping_cart_outlined,
                                      size: 20 * sW,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                '${cartList[i].product.name}. Size: ${cartList[i].product.size[cartList[i].sizeIndex]}',
                                style: GoogleFonts.tenorSans(
                                  fontSize: 12 * sW,
                                  color: const Color(0xFF555555),
                                ),
                              ),

                              DrawCountArea(cartItemIndex: i),

                              Text(
                                '${cartList[i].product.price} ${cartList[i].product.currency}',
                                style: GoogleFonts.tenorSans(
                                  fontSize: 15 * sW,
                                  color: const Color(0xFFDD8560),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // checkout button
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawCountArea extends ConsumerStatefulWidget {
  const DrawCountArea({super.key, required this.cartItemIndex});

  final int cartItemIndex;

  @override
  ConsumerState<DrawCountArea> createState() => _DrawCountAreaState();
}

class _DrawCountAreaState extends ConsumerState<DrawCountArea> {
  @override
  Widget build(BuildContext context) {
    final cartListItem = ref.read(cartProvider)[widget.cartItemIndex];
    final cartListNotifier = ref.read(cartProvider.notifier);
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    debugPrint(widget.cartItemIndex.toString());

    return SizedBox(
      width: double.infinity,
      height: 24 * sH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (cartListItem.count == 1) return;
              cartListNotifier.updateCount(widget.cartItemIndex, cartListItem.count - 1);
              setState(() {});
            },
            child: Container(
              height: 22 * sH,
              width: 22 * sW,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: const Color(0xFFC4C4C4)),
              ),
              child: Center(child: Icon(Icons.remove, size: 16 * sW)),
            ),
          ),

          SizedBox(width: 8.5 * sW),

          Text(
            cartListItem.count.toString(),
            style: GoogleFonts.tenorSans(
              fontSize: 16 * sW,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(width: 8.5 * sW),

          GestureDetector(
            onTap: () {
              cartListNotifier.updateCount(widget.cartItemIndex, cartListItem.count + 1);
              setState(() {});
            },
            child: Container(
              height: 22 * sH,
              width: 22 * sW,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: const Color(0xFFC4C4C4)),
              ),
              child: Center(child: Icon(Icons.add, size: 16 * sW)),
            ),
          ),
        ],
      ),
    );
  }
}
