import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/ItemShowByCategory.dart';

class NewArrivalScroll extends StatefulWidget {
  const NewArrivalScroll({super.key, required this.sW, required this.categories, required this.catalog});

  final double sW;
  final List categories;
  final List catalog;

  @override
  State<NewArrivalScroll> createState() => _NewArrivalScrollState();
}

class _NewArrivalScrollState extends State<NewArrivalScroll> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 750 * widget.sW,

      child: Column(
        children: [
          SizedBox(height: 6.5 * widget.sW,),

          Text(
            'New Arrival',
            style: GoogleFonts.tenorSans(
                fontSize: 32 * widget.sW,
                letterSpacing: 2.5
            ),
          ),

          SizedBox(
            width: 125 * widget.sW,
            height: 9.25 * widget.sW,
            child: Image.asset(
              'lib/Images/HomePage/Logo/Line.png',
              color: Colors.black,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 23 * widget.sW,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for(int i = 0; i < widget.categories.length; ++i)...[
                GestureDetector(
                  onTap: () {
                    if (widget.categories[i][1]) return;

                    for(int i2 = 0; i2 < widget.categories.length; ++i2){
                      widget.categories[i2][1] = false;
                    }
                    widget.categories[i][1] = true;

                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.categories[i][0].toString(),
                        style: GoogleFonts.tenorSans(
                            color: widget.categories[i][1] == true ? Color(0xFF212806) : Color(0xFF888888),
                            fontSize: 20 * widget.sW
                        ),
                      ),

                      Text(
                        '◆',
                        style: TextStyle(
                          color: widget.categories[i][1] ? Color(0xFFDD8560) : Colors.transparent,
                          // fontSize: 20 * sW
                        ),
                      )
                    ],
                  ),
                )
              ]
            ],
          ),

          SizedBox(height: widget.sW * 0.025,),

          Expanded(
            child: ItemShowByCategory(
              key: ValueKey(widget.key),
              category: getSelectedCategory(),
              itemList: widget.catalog,
              sW: widget.sW,
            )
          ),

          MaterialButton(
              onPressed: (){},
              child: SizedBox(
                width: 155 * widget.sW,
                height: 48 * widget.sW,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Explore more',
                      style: GoogleFonts.tenorSans(
                        fontSize: 20 * widget.sW,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      )
                    ),
                    Icon(Icons.arrow_forward,)
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  String getSelectedCategory(){
    for (int i = 0; i < widget.categories.length; ++i){
      if (widget.categories[i][1]) return widget.categories[i][0];
    }
    return "";
  }
}
