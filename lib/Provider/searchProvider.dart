import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchKeywords extends Notifier<List<List<dynamic>>>{
  final List<List<dynamic>> test = [];//[['test1', true], ['test2', true], ['test3', true], ['test4', true], ['test5', true],['test6', true], ['test7', true], ['test8', true], ['test9', true], ['test10', true]];

  @override
  List<List> build() {
    return test;
  }

  List<List<dynamic>> get(){
    return state;
  }

  void clear(){
    state = test;
  }

  void addToKeywords(List<dynamic> keyword) {
    if (contain(keyword[0])) return;

    if (!keyword[1]){
      state = [...state, keyword];
    }else{
      for (int i = 0; i < state.length; ++i){
        if (state[i][1]){
          var state1 = [ for (final item in state) [...item] ];
          state1[i][0] = keyword[0];
          state = state1;
          return;
        }
      }

      state = [...state, keyword];
    }
  }

  void removeFromKeywords(String keyword) {
    state = state.where((kw) => kw[0] != keyword).toList();
  }

  bool contain(String keyword){
    for (int i = 0; i < state.length; ++i){
      if (keyword == state[i][0]) return true;
    }
    return false;
  }
}
final searchKeywordsProvider = NotifierProvider<SearchKeywords, List<List<dynamic>>>(() {
  return SearchKeywords();
},);


class ItemsGridView extends Notifier<bool>{
  @override
  bool build() {
    return true;
  }

  void change(){
    state = !state;
  }
}
final gridViewProvider = NotifierProvider<ItemsGridView, bool>(() {
  return ItemsGridView();
},);


class FilterView extends Notifier<bool>{
  @override
  bool build() {
    return false;
  }

  void change(){
    state = !state;
  }
}
final filterProvider = NotifierProvider<FilterView, bool>(() {
  return FilterView();
},);


