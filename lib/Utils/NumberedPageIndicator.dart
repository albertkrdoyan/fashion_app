import 'package:fashion_app/Provider/NumberedPageIndicatorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final scrollController = ScrollController();

class NumberedPageIndicator extends ConsumerWidget {
  const NumberedPageIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.of(context).size.width / 375;
    PageIndicator pi = ref.watch(numberedPageIndicatorProvider);
    int st = (
      pi.currentPage > 3
        ? pi.currentPage < pi.totalPagesCount - 4
          ? pi.currentPage - 2
          : pi.totalPagesCount - 5
        : 0
    );

    int end = st + 5 > pi.totalPagesCount - 1 ? pi.totalPagesCount : st + 5;

    return SizedBox(
      height: 30 * sW ,
      child: Column(children: [
        if (pi.totalPagesCount < 9)...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < pi.totalPagesCount; ++i)...[
                PageSquare(sW: sW, index: i, pi: pi)
              ]
            ],
          )
        ]
        else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pi.currentPage > 3)...[
                PageSquare(sW: sW, index: 0, pi: pi),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0 * sW),
                  child: Text(
                    '...',
                    style: GoogleFonts.tenorSans(
                      fontSize: 16 * sW,
                      color: const Color(0xFF555555)
                    ),
                  ),
                )
              ],

              for (int i = st; i < end; ++i)...[
                PageSquare(sW: sW, index: i, pi: pi)
              ],

              if (pi.currentPage < pi.totalPagesCount - 4)...[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0 * sW),
                  child: Text(
                    '...',
                    style: GoogleFonts.tenorSans(
                        fontSize: 16 * sW,
                        color: const Color(0xFF555555)
                    ),
                  ),
                ),

                PageSquare(sW: sW, index: pi.totalPagesCount - 1, pi: pi),
              ],
            ]
          )
        ]
      ],),
    );
  }
}

class PageSquare extends ConsumerWidget {
  const PageSquare({super.key, required this.sW, required this.index, required this.pi});

  final double sW;
  final PageIndicator pi;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (pi.currentPage == index) return;
        ref.read(numberedPageIndicatorProvider.notifier).changeCurrentPage(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3 * sW),
        height: 30 * sW,
        width: 30 * sW,
        color: pi.currentPage == index ? const Color(0xFF333333) : const Color(0xFFDEDEDE),
        child: Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.tenorSans(
                  fontSize: 16 * sW,
                  color: pi.currentPage == index ? Colors.white : const Color(0xFF555555)
              ),
            )
        ),
      ),
    );
  }
}