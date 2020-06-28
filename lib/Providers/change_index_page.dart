import 'package:flutter/material.dart';

class ChangeIndex with ChangeNotifier {
  int index =2;


  void changeIndexFunction(int index) {
    this.index = index;
    notifyListeners();
  }
  void changeIndexFunctionWithOutNotify(int index) {
    this.index = index;
  }
  
}