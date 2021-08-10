import 'package:flutter/material.dart';
import 'package:holdem_pub/view/shop_manage_setting.dart';

class ShopManage extends StatefulWidget {
  const ShopManage({Key? key}) : super(key: key);
  @override
  _ShopManageState createState() => _ShopManageState();
}

class _ShopManageState extends State<ShopManage> {
  String description = "~~~~~~~~~~";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('관리자 페이지'),
        ),
        body: Column(
          children: [
            // 매장 이름
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '매장 1',
                style: TextStyle(fontSize: 18),
              ),
            ),

            // 매장 정보 변경
            Container(
              // width: 100,
              // height: 100,
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // SizedBox(
              //     //     child: Image.network('https://picsum.photos/250?image=9')),
              //     // TextFiled로 내용 수정 가능
              //     Container(
              //       width: 100,
              //       height: 100,
              //       child: TextField(
              //         decoration: InputDecoration(
              //           // icon: Icon(Icons.shop),
              //           border: OutlineInputBorder(),
              //           labelText: description,
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ),

            // 예약인원 설정 및 현재인원 설정 버튼
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopManageSetting()),
                    );
                  }, child: Text('예약 설정')),

                  // TextButton(onPressed: () {}, child: Text('현재 인원 설정')),
                ],
              ),
            ),

            // 예약자 현황
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),

              /// Listbuilder로 변경하기 (동적 생성)
              // Local 데이터로 삭제 및 수락 가능하도록
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Text(
                    '예약자 현황 \n',
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('닉네임'),
                        TextButton(onPressed: (){
                          // 게임 대기 인원으로 내리기
                        }, child: Text('현재인원으로 전환')),
                        TextButton(onPressed: (){
                          // List 삭제
                        }, child: Text('취소')),
                      ],
                    ),

                  ),
                ],
              ),
            ),

            // 게임 대기 인원 (매장 내 있는 인원)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Text(
                    '게임 대기 인원 \n',
                    style: TextStyle(fontSize: 18),
                  ),
                  ListTile(
                    leading: Text('닉네임'),
                  ),
                  ListTile(
                    leading: Text('닉네임'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

