import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sW = MediaQuery.of(context).size.width / 375;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 60 * sW,
        title: Image.asset('lib/Images/HomePage/Logo/Logo.png'),
      ),
    );
  }
}
