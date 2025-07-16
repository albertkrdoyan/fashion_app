import 'package:fashion_app/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSizeSelection extends ConsumerStatefulWidget {
  const ProductSizeSelection({super.key, required this.product});

  final Product product;
  static int selectedSizeO = 0;

  @override
  ConsumerState<ProductSizeSelection> createState() => _ProductSizeSelectionState();
}
class _ProductSizeSelectionState extends ConsumerState<ProductSizeSelection> {
  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.sizeOf(context).width / 375;

    ProductSizeSelection.selectedSizeO = selectedSize;

    return Row(
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
    );
  }
}
