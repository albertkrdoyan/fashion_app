import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends Notifier<List<List<dynamic>>>{
  @override
  List<List> build() {
    return [ ['All', true] ];
  }

  void changeData(List<List<dynamic>> newData){
    for (int i = 0; i < newData.length; ++i){
      state.add(newData[i].last);
    }
  }
}

final categoriesProvider = NotifierProvider<CategoriesNotifier, List<List<dynamic>>>(() {
  return CategoriesNotifier();
},);
