import 'package:fashion_app/Pages/CartPage.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPageLoader extends StatelessWidget {
  const CartPageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CartPage(),),
          );
        },
        child: Consumer(
          builder: (_, ref, _) {
            final cartList = ref.watch(cartProvider);
            final isMaxCart = cartList.length > 99;

            return Padding(
              padding: EdgeInsets.only(right: 23 * sW),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset('lib/Images/HomePage/Logo/ShoppingBag.svg', height: 25 * sW, width: 20 * sW,),
                  if(cartList.isNotEmpty)
                    Transform.translate(
                    offset: Offset(10 * sW, -10 * sW),
                    child: Container(
                      padding: EdgeInsets.all(2.5 * sW),
                      height: 17 * sW,
                      width: (isMaxCart ? 25 : 17) * sW,
                      decoration: BoxDecoration(
                        shape: isMaxCart ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: isMaxCart ? BorderRadius.circular(6 * sW) : null,
                        color: const Color(0xFFDD8560),
                      ),
                      child: Center(
                        child: Text(
                        isMaxCart ? '99+' : cartList.length.toString(),
                        style: GoogleFonts.tenorSans(fontSize: 9 * sW,letterSpacing: 0),)
                      )
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }
}
