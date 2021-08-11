import 'package:flutter/material.dart';

class ShopData with ChangeNotifier {
  String shopName = "테스트";
  String shopImage = "https://picsum.photos/250?image=9";
  String _shopInfo = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~테스트 1";

  int _reserveNum = 0;
  int _nowNum = 0;

  String getInfo() => _shopInfo;
  int getReserveNum() => _reserveNum;
  int getNowNum() => _nowNum;

  void changeInfo(String input){
    _shopInfo = input;
    notifyListeners(); //must be inserted
  }

  void reserve_increment() {
    _reserveNum++;
    notifyListeners(); //must be inserted
  }

  void reserve_decrement() {
    _reserveNum--;
    notifyListeners(); //must be inserted
  }

  void now_increment() {
    _nowNum++;
    notifyListeners(); //must be inserted
  }

  void now_decrement() {
    _nowNum--;
    notifyListeners(); //must be inserted
  }

}