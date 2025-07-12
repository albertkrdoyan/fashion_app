import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jsonDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    final values = await Future.wait([
      rootBundle.loadString('lib/JSONS/main_page.json'),
      rootBundle.loadString('lib/JSONS/trends.json'),
      rootBundle.loadString('lib/JSONS/followUs.json'),
      rootBundle.loadString('lib/JSONS/openFashion.json'),
    ]);

    final query = await FirebaseFirestore.instance.collection('catalog').get();
    final catalogList = query.docs.map((doc) => doc.data()).toList();

    return {
      'mainPage': jsonDecode(values[0]),
      'trends': jsonDecode(values[1]),
      'followUs': jsonDecode(values[2]),
      'openFashion': jsonDecode(values[3]),
      'catalog': catalogList,
    };
  } catch (e) {
    throw Exception('Failed to load Firestore data: $e');
  }
});