import 'package:fashion_app/Models/Products.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSizeSelection extends ConsumerStatefulWidget {
  const ProductSizeSelection({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductSizeSelection> createState() => _ProductSizeSelectionState();
}

class _ProductSizeSelectionState extends ConsumerState<ProductSizeSelection> {
  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width / 375;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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

            if (widget.product.size.length == 1)...[
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
                    widget.product.size[0],
                    style: GoogleFonts.tenorSans(
                        fontSize: 16 * sW,
                        color: const Color(0xFF555555)
                    ),
                  ),
                ),
              )
            ]else...[
              for (int i = 0; i < widget.product.size.length; ++i)...[
                GestureDetector(
                  onTap: () {
                    if (i == selectedSize) return;

                    setState(() {
                      selectedSize = i;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 6 * sW),
                    height: 28 * sW,
                    width: 28 * sW,
                    decoration: BoxDecoration(
                      color: i == selectedSize ? const Color(0xFF333333) : Colors.transparent,
                      border: Border.all(
                        width: 1 * sW,
                        color: const Color(0xFFE3E3E3),
                      ),
                      shape: BoxShape.circle
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.product.size[i],
                        style: GoogleFonts.tenorSans(
                          fontSize: 10 * sW,
                          color: i == selectedSize ? const Color(0xFFFFFFFF) : const Color(0xFF555555),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ]
          ],
        ),
        SizedBox(width: 15 * sW,),
        GestureDetector(
          onTap: () {
            ref.read(cartProvider.notifier).addToCart(widget.product, 1, selectedSize);
            // debugPrint(widget.product.name);
          },
          child: Container(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10 * sW,),
                Icon(Icons.add_shopping_cart_sharp, color: Colors.white, size: 28 * sW,),
                SizedBox(width: 10 * sW,),
                Text(
                  " ADD",
                  style: GoogleFonts.tenorSans(
                    color: Colors.white,
                    fontSize: 14 * sW
                  ),
                ),
                SizedBox(width: 10 * sW,),
              ],
            ),
          ),
        )
      ],
    );
  }
}
