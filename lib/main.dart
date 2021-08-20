import 'package:flutter/material.dart';
import 'package:holdem_pub/view/shop.dart';
import 'package:holdem_pub/view/shop_manage.dart';
import 'package:provider/provider.dart';
import 'model/ShopData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (BuildContext context) => ShopData(),
    ),
    Provider(
      create: (context) => ShopList(),
    ),

    Provider(
      create: (context) => ShopInformation(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShopList(),
    );
  }
}

class ShopList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    late ShopData _shopdata;
    _shopdata = Provider.of<ShopData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop List'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('${_shopdata.shopName}(관리자)'),
            trailing: Column(
              children: [
                Text('예약자 : ${_shopdata.getReserveNum()}명'),
                Text('게임인원 : ${_shopdata.getGameNum()}명'),
              ],
            ),
            onTap: () {
              FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
              String temp;
              firestoreInstance
                  .collection('Shop').doc('jackpotrounge').get().then((value) {
                print('value: ${value.data()!['shop_info']}');
                temp = value.data()!['shop_info'];

                // 매장 상세 정보 페이지 (Navigator)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopManage(introText: temp)),
                );
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('${_shopdata.shopName}(사용자)'),
            trailing: Column(
              children: [
                Text('예약자 : ${_shopdata.getReserveNum()}명'),
                Text('게임인원 : ${_shopdata.getGameNum()}명'),
              ],
            ),
            onTap: () {
              // 매장 상세 정보 페이지 (Navigator)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopInformation()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('매장3'),
            trailing: Column(
              children: [
                Text('예약자 : ~명'),
                Text('게임인원 : ~명'),
              ],
            ),
            onTap: () {
              // 매장 상세 정보 페이지 (Navigator)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopInformation()),
              );
            },
          ),
        ],
      ),
    );
  }
}
