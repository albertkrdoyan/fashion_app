import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StringNotifier extends Notifier<String>{
  @override
  String build() {
    return "";
  }

  void changeData(String newData){
    state = newData;
  }
}

final dataProvider = NotifierProvider<StringNotifier, String>(() {
  return StringNotifier();
},);