import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopData with ChangeNotifier {
  final _firestoreInstance = FirebaseFirestore.instance;

  String shopName = "테스트";
  String shopImage = "https://picsum.photos/250?image=9";
  String _shopInfo = "테스트 1";

  int _reserveNum = 0;
  int _gameNum = 0;

  String getInfo() => _shopInfo;
  int getReserveNum() => _reserveNum;
  int getGameNum() => _gameNum;

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

  void game_increment() {
    _gameNum++;
    notifyListeners(); //must be inserted
  }

  void game_decrement() {
    _gameNum--;
    notifyListeners(); //must be inserted
  }

}