import 'package:fashion_app/Models/Products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final Product product;
  int count;
  int sizeIndex;

  CartItem({
    required this.product,
    required this.count,
    required this.sizeIndex,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other)
        || other is CartItem
        && runtimeType == other.runtimeType
        && product == other.product
        && sizeIndex == other.sizeIndex;
  }

  @override
  int get hashCode => Object.hash(product, sizeIndex);
}


class CartProvider extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addToCart(Product product, int count, int sizeIndex) {
    CartItem cartItem = CartItem(product: product, count: count, sizeIndex: sizeIndex);
    int index = _contains(cartItem);

    if (index == -1) {
      state = [...state, cartItem];
    } else {
      updateCount(index, state[index].count + 1);
    }
  }

  void updateCount(int index, int newCount) {
    state = [
      for (int i = 0; i < state.length; ++i)
        if (index == i)
          CartItem(product: state[index].product, count: newCount, sizeIndex: state[index].sizeIndex)
        else
          state[index]
    ];
  }

  int _contains(CartItem cartItem){
    for (int i = 0; i < state.length; ++i){
      if (state[i] == cartItem) return i;
    }

    return -1;
  }
}

final cartProvider = NotifierProvider<CartProvider, List<CartItem>>(() => CartProvider());