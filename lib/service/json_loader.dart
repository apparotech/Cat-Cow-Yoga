
import 'dart:convert';
import 'package:flutter/services.dart';

import '../Model/yoga_sequence.dart';


Future<YogaSession> loadYogaSession() async {
  String jsonString = await rootBundle.loadString('assets/poses.json');
  final jsonData = json.decode(jsonString);
  return YogaSession.fromJson(jsonData);
}