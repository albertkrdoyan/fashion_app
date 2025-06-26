import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jsonDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final bundle = rootBundle; // You can also use DefaultAssetBundle if needed

  final values = await Future.wait([
    bundle.loadString('lib/JSONS/main_page.json'),
    bundle.loadString('lib/JSONS/catalog.json'),
    bundle.loadString('lib/JSONS/trends.json'),
    bundle.loadString('lib/JSONS/followUs.json'),
    bundle.loadString('lib/JSONS/openFashion.json'),
  ]);

  return {
    'mainPage': jsonDecode(values[0]),
    'catalog': jsonDecode(values[1]),
    'trends': jsonDecode(values[2]),
    'followUs': jsonDecode(values[3]),
    'openFashion': jsonDecode(values[4]),
  };
});