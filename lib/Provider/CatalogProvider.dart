import 'package:fashion_app/Models/Products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCatalogProvider extends Notifier<List<Product>>{
  @override
  List<Product> build() {
    return [];
  }

  void updateList(List<dynamic> catalog) {
    state = catalog
        .whereType<Map<String, dynamic>>() // Ensures each item is a Map
        .map((json) => Product.fromJson(json))
        .toList();
  }

  List<Product> filterByCategory(String category){
    List<Product> result = [];

    String cat1 = "", cat2 = "", cat3 = "";
    int i = 0;

    for (i; i < category.length && category[i] != '/'; ++i) {
      cat1 += category[i];
    }
    for (i++; i < category.length && category[i] != '/'; ++i){
      cat2 += category[i];
    }
    for (i++; i < category.length; ++i){
      cat3 += category[i];
    }

    cat1 = cat1.substring(0, cat1.length - 1);
    cat2 = cat2.substring(1, cat2.length - 1);
    cat3 = cat3.substring(1, cat3.length);

    bool isAll = cat3 == "All";

    for (i = 0; i < state.length; ++i){
      if (state[i].category[0] == cat1 && state[i].category[1] == cat2 && (isAll || state[i].category[2] == cat3)){
        result.add(state[i]);
      }
    }

    return result;
  }
}

final productCatalogProvider = NotifierProvider<ProductCatalogProvider, List<Product>>(() => ProductCatalogProvider(),);