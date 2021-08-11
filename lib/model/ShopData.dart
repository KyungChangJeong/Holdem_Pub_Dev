import 'package:flutter/material.dart';

class ShopData with ChangeNotifier {
  String shopName = "테스트";
  String shopImage = "https://picsum.photos/250?image=9";
  String _shopInfo = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~테스트 1";

  var ReserveUser = [
    // {'nickname': '예약1', 'name': '선명', 'phonenumber': '010-2620-5991'},
    // {'nickname': '예약2', 'name': '경민', 'phonenumber': '010-1230-5991'},
    // {'nickname': '예약3', 'name': '경창', 'phonenumber': '010-8720-8661'},
    // {'nickname': '예약4', 'name': '제현', 'phonenumber': '010-215691'},
    // {'nickname': '예약5', 'name': '우석', 'phonenumber': '05405'}
  ];
  var GameUser = [
    // {'nickname': '게임1', 'name': '당당', 'phonenumber': '010-1561-8661'},
    // {'nickname': '게임2', 'name': '수구리', 'phonenumber': '010-2156-1591'},
    // {'nickname': '게임3', 'name': '굳굳', 'phonenumber': '010-1150-5991'},
  ];



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