import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  void changePage(int selectedPage) {
    _selectedPage = selectedPage;
    notifyListeners();
  }
}
