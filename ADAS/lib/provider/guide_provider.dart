import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuideProvider with ChangeNotifier {
  bool _seenGuide = false;
  bool get seenGuide => _seenGuide;

  GuideProvider() {
    _checkIfSeenGuide();
  }

  Future<void> _checkIfSeenGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _seenGuide = prefs.getBool('seenGuide') ?? false;

    if (!_seenGuide) {
      await prefs.setBool('seenGuide', true);
    }

    notifyListeners();
  }

  Future<void> setSeenGuide(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _seenGuide = value;
    await prefs.setBool('seenGuide', value);
    notifyListeners();
  }
}
