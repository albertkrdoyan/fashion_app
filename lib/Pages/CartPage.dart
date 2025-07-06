import 'dart:math' as math;

import 'package:fashion_app/Models/svgImages.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:fashion_app/Utils/pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    final cartList = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60 * sW,
        title: Image.asset('lib/Images/HomePage/Logo/Logo.png'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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

                      SizedBox(height: 18 * sH,),

                      for (int i = 0; i < cartList.length; ++i) ...[
                        Container(
                          height: 135 * sH,
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
                              Image.asset(
                                cartList[i].product.path,
                                width: 100 * sW,
                                height: 135 * sH,
                                fit: BoxFit.cover,
                              ),

                              SizedBox(width: 11 * sW),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    cartList[i].product.brand,
                                    style: GoogleFonts.tenorSans(
                                      fontSize: 14 * sW,
                                      letterSpacing: 2 * sW,
                                    ),
                                  ),

                                  Text(
                                    cartList[i].product.name,
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
                            ],
                          ),
                        ),
                      ],

                      // checkout button
                      const Spacer(),
                      MaterialButton(
                        onPressed: () {},
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
                            : GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.string(
                                      shoppingBagReverseSVG,
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
                      ),
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

class DrawCountArea extends ConsumerWidget {
  const DrawCountArea({super.key, required this.cartItemIndex});

  final int cartItemIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartListItem = ref.watch(cartProvider)[cartItemIndex];

    debugPrint(cartItemIndex.toString());

    return Container(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(cartProvider.notifier).updateCount(cartListItem.product, cartListItem.count - 1);
            },
            child: Container(
              height: 25,
              width: 25,
              child: Text('-'),
            ),
          ),

          Text(cartListItem.count.toString()),

          GestureDetector(
            onTap: () {
              ref.read(cartProvider.notifier).updateCount(cartListItem.product, cartListItem.count + 1);
            },
            child: Container(
              height: 25,
              width: 25,
              child: Text('+'),
            ),
          )
        ],
      ),
    );
  }
}

