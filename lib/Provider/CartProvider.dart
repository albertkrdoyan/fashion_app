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
      updateCount(state[index].product, state[index].count);
    }
  }

  void updateCount(Product product, int newCount) {
    state = [
      for (final item in state)
        if (item.product == product)
          CartItem(product: item.product, count: newCount, sizeIndex: item.sizeIndex)
        else
          item
    ];
  }

  void updateSizeIndex(Product product, int newSizeIndex) {
    state = [
      for (final item in state)
        if (item.product == product)
          CartItem(product: item.product, count: item.count, sizeIndex: newSizeIndex)
        else
          item
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