import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  List wList = [
    ['WOMEN', true],
    ['MAN', false],
    ['KIDS', false],
    ['', false]
  ];

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 640;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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

            Padding(
              padding: EdgeInsets.only(top: 20 * sH, left: 18 * sW, right: 17 * sW),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < widget.wList.length; ++i)...[
                    GestureDetector(
                      onTap: () {
                        if (i == 3 || widget.wList[i][1]) return;

                        for (int i1 = 0; i1 < widget.wList.length; ++i1) {
                          widget.wList[i1][1] = false;
                        }

                        widget.wList[i][1] = true;
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Text(
                            widget.wList[i][0],
                            style: GoogleFonts.tenorSans(
                              fontSize: 14 * sW,
                              letterSpacing: 3 * sW
                            ),
                          ),
                          SizedBox(height: (widget.wList[i][1] ? 4 : 5) * sH,),
                          Container(
                            width: 85 * sW,
                            height: (widget.wList[i][1] ? 3 : 1) * sH,
                            color: widget.wList[i][1] ? Color(0xFFDD8560) : Color(0xFF888888),
                          ),
                          if(!widget.wList[i][1])...[
                            SizedBox(height: 1 * sH,),
                          ]
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),

            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
