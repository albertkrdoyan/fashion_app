import 'package:fashion_app/Models/Products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartProvider extends Notifier<List<dynamic>>{
  @override
  List<Product> build() {
    return [];
  }

  void addToCart(Product product, int count, int sizeIndex){
    state = [...state, [product, count, sizeIndex]];
  }
}

final cartProvider = NotifierProvider<CartProvider, List<dynamic>>(() => CartProvider(),);