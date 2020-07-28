import 'package:flutter/material.dart';

class ChangeIndex with ChangeNotifier {
  int index =4;


  void changeIndexFunction(int index) {
    this.index = index;
    notifyListeners();
  }
  void changeIndexFunctionWithOutNotify(int index) {
    this.index = index;
  }
  
}