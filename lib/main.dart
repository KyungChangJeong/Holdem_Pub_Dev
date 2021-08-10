import 'package:flutter/material.dart';
import 'package:holdem_pub/view/shop.dart';
import 'package:holdem_pub/view/shop_manage.dart';

void main() {
  runApp(MyApp());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop List'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('매장1'),
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
                MaterialPageRoute(builder: (context) => ShopManage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('매장2'),
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
