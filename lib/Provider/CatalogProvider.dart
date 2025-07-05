import 'package:fashion_app/Models/Products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCatalogProvider extends Notifier<List<Product>>{
  @override
  List<Product> build() {
    return [];
  }

  void updateList(List<dynamic> catalog) {
    List<Product> result = [];

    for (int i = 0; i < catalog.length; ++i) {
      var json = catalog[i];
      if (json is Map<String, dynamic>) {
        result.add(Product.fromJson(json, i + 1));
      }
    }

    state = result;
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


class CategoriesProvider extends Notifier<List<List<String>>>{
  @override
  List<List<String>> build() {
    return [];
  }

  void update(List<Product> listOfProducts){
    Set<KeyList> categories = {};

    for (int i = 0; i < listOfProducts.length; ++i){
      categories.add(KeyList(listOfProducts[i].category));
    }

    for (var list in categories){
      state.add(list.values);
    }

    state = [...state];
  }
}
final productCategoriesProvider = NotifierProvider<CategoriesProvider, List<List<String>>>(() => CategoriesProvider(),);


class KeyList {
  final List<String> values;

  KeyList(this.values);

  @override
  bool operator ==(Object other) =>
      other is KeyList &&
          _listEquals(values, other.values);

  @override
  int get hashCode => values.fold(0, (h, v) => h ^ v.hashCode);

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; ++i) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}