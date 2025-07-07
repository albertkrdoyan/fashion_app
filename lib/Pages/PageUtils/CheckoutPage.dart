import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fashion_app/Models/svgImages.dart';
import 'package:fashion_app/Provider/CartProvider.dart';
import 'package:fashion_app/Provider/ShippingAddressProvider.dart';
import 'package:fashion_app/Utils/pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final List<List<dynamic>> shippingMethods = [
    ['Standard Shipping, 3–7 business days', 1900.0],
    ['Express Shipping, 1–3 business days', 4900.0],
    ['In-Store Pickup', 0.0]
  ];
  List<dynamic>? selectedShippingMethod;
  double additionalFee = 0.0;

  final List<List<dynamic>> payMethods = [
    ['Credit card', Icons.credit_card],
    ['Cash', Icons.money]
  ];
  List<dynamic>? selectedPayMethod;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    final cartList = ref.read(cartProvider);
    final cartListNotifier = ref.read(cartProvider.notifier);

    debugPrint('CheckoutPage');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60 * sW,
        title: Image.asset('lib/Images/HomePage/Logo/Logo.png'),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 86 * sH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
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
                      '${cartListNotifier.getTotalPrice() + additionalFee} ${cartList[0].product.currency}',
                      style: GoogleFonts.tenorSans(
                        color: const Color(0xFFDD8560),
                        fontSize: 20 * sW,
                        letterSpacing: 2 * sW
                      ),
                    )
                  ],
                ),
              ),

              MaterialButton(
                onPressed: () {},
                height: 56 * sH,
                minWidth: 375 * sW,
                color: Colors.black,
                child: GestureDetector(
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
                        'PLACE ORDER',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 33 * sH),

                // header
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

                // shipping method
                SizedBox(height: 36 * sH),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16 * sW, bottom: 12 * sH),
                  child: Text(
                    'shipping method'.toUpperCase(),
                    style: GoogleFonts.tenorSans(
                      fontSize: 14 * sW,
                      color: const Color(0xFF555555),
                      letterSpacing: 1 * sW
                    ),
                  ),
                ),
                SizedBox(
                  width: 342 * sW,
                  height: 48 * sH,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<List<dynamic>>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            size: 20 * sW,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 4 * sW,
                          ),
                          Expanded(
                            child: Text(
                              'Select the method you would like.',
                              style: TextStyle(
                                fontSize: 14 * sW,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: shippingMethods.map((List<dynamic> item) => DropdownMenuItem<List<dynamic>>(
                        value: item,
                        child: Text(
                          '${item[0]}, ${item[1] == 0 ? 'Free' : '${item[1]} AMD'}',
                          style: TextStyle(
                            fontSize: 12 * sW,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )).toList(),
                      value: selectedShippingMethod,
                      onChanged: (value) {
                        if (selectedShippingMethod == value) return;

                        setState(() {
                          additionalFee -= selectedShippingMethod?[1]??0;
                          selectedShippingMethod = value;
                          additionalFee += selectedShippingMethod?[1];
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50 * sH,
                        width: 160 * sW,
                        padding: EdgeInsets.symmetric(horizontal: 14 * sW),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: const Color(0xFFF9F9F9),
                        ),
                        elevation: 10,
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(Icons.arrow_drop_down,),
                        iconSize: 25 * sW,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200 * sH,
                        width: 342 * sW,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: Radius.circular(40 * sW),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                    ),
                  ),
                ),

                // shipping address
                if (selectedShippingMethod != null && selectedShippingMethod![1] != 0)...[
                  SizedBox(height: 36 * sH),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16 * sW, bottom: 0 * sH),
                    child: Text(
                      'shipping address'.toUpperCase(),
                      style: GoogleFonts.tenorSans(
                          fontSize: 14 * sW,
                          color: const Color(0xFF555555),
                          letterSpacing: 1 * sW
                      ),
                    ),
                  ),
                  const ShippingAddressView(),
                ],

                // payment method
                SizedBox(height: 36 * sH),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16 * sW, bottom: 12 * sH),
                  child: Text(
                    'payment method'.toUpperCase(),
                    style: GoogleFonts.tenorSans(
                        fontSize: 14 * sW,
                        color: const Color(0xFF555555),
                        letterSpacing: 1 * sW
                    ),
                  ),
                ),
                SizedBox(
                  width: 342 * sW,
                  height: 48 * sH,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<List<dynamic>>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Icon(
                            Icons.payment,
                            size: 20 * sW,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 4 * sW,
                          ),
                          Expanded(
                            child: Text(
                              'Select the method you would like.',
                              style: TextStyle(
                                fontSize: 14 * sW,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: payMethods.map((List<dynamic> item) => DropdownMenuItem<List<dynamic>>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(item[1]),
                            Text(
                              item[0],
                              style: TextStyle(
                                fontSize: 12 * sW,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )).toList(),
                      value: selectedPayMethod,
                      onChanged: (value) {
                        if (selectedPayMethod == value) return;
                        setState(() {
                          selectedPayMethod = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50 * sH,
                        width: 160 * sW,
                        padding: EdgeInsets.symmetric(horizontal: 14 * sW),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: const Color(0xFFF9F9F9),
                        ),
                        elevation: 10,
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(Icons.arrow_drop_down,),
                        iconSize: 25 * sW,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200 * sH,
                        width: 342 * sW,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: Radius.circular(40 * sW),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                    ),
                  ),
                ),
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

class ShippingAddressView extends ConsumerWidget {
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.of(context).size.width / 375;
    double sH = MediaQuery.of(context).size.height / 797;

    final shippingAddressesList = ref.read(shippingAddressProvider);
    final shippingAddressesListNotifier = ref.watch(shippingAddressProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shippingAddressesList.isNotEmpty)
          ShippingAddressDraw(shippingAddress: shippingAddressesList.first),

        // add shipping address
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * sW),
          child: MaterialButton(
            onPressed: (){},
            minWidth: 342 * sW,
            height: 48 * sH,
            color: const Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: const BorderSide(
                color: Colors.black26,  // border color
                width: 1.0,           // border width
              ),
            ),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add shipping address',
                  style: GoogleFonts.tenorSans(
                    color: const Color(0xFF555555),
                    fontSize: 16 * sW
                  ),
                ),

                const Icon(Icons.add, size: 35, color: Colors.black,),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ShippingAddressDraw extends StatelessWidget {
  const ShippingAddressDraw({super.key, required this.shippingAddress});
  final ShippingAddress shippingAddress;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width / 375;

    final style = GoogleFonts.tenorSans(
      color: const Color(0xFF555555),
      fontSize: 12 * sW,
    );

    return Container(
      padding: EdgeInsets.all(8 * sW),
      margin: EdgeInsets.symmetric(vertical: 8 * sW, horizontal: 16 * sW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${shippingAddress.firstName} ${shippingAddress.lastName}', style: style.copyWith(fontSize: 14 * sW, color: Colors.black),),

              Text('${shippingAddress.city}, ${shippingAddress.address}, Zip: ${shippingAddress.zipCode}', style: style,),

              Text('${shippingAddress.country}, ${shippingAddress.stateOrRegion}', style: style,),

              Text(shippingAddress.phoneNumber, style: style,),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0 * sW),
            child: Icon(Icons.keyboard_arrow_right_outlined, size: 25 * sW,),
          )
        ],
      ),
    );
  }
}
