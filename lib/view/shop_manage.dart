import 'package:flutter/material.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:holdem_pub/view/shop_manage_setting.dart';
import 'package:holdem_pub/view/shop.dart';
import 'package:provider/provider.dart';

class ShopManage extends StatefulWidget {
  const ShopManage({Key? key}) : super(key: key);

  @override
  _ShopManageState createState() => _ShopManageState();
}

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

class _ShopManageState extends State<ShopManage> {
  String description = "~~~~~~~~~~";

  // Radio ListTile구현
  String _gameTableFlag = 'Wating';
  String _shopFlag = 'Closed';

  Map<String, String> temp = {
    'nickname': '직접예약',
    'name': '알수없음',
    'phonenumber': ''
  };

  // 바 컨트롤러 생성
  final ScrollController _scrollController = ScrollController();

  // 소개글 수정 컨트롤러
  final _InformationTextEdit = TextEditingController();

  @override
  void dispose() {
    _InformationTextEdit.dispose();
    super.dispose();
  }

  /// slidable로 변경
  void _showMaterialDialog(Map<String, String> status, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('상태 변경'),
            // content: Text('ㅎㅇ'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                    print('status: $status');
                    // 예약 => 게임
                    setState(() {
                      // ReserveUser에서 status 삭제
                      ReserveUser.removeAt(index);
                      // GameUser에 status 추가
                      GameUser.add(status);
                    });
                  },
                  child: Text('수락')),
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: Text('취소'),
              )
            ],
          );
        });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('관리자 페이지'),
        ),
        body: Scrollbar(
          // <- ScrollBar에 컨트롤러를 알려준다
          controller: _scrollController,
          // <- 화면에 항상 스크롤바가 나오도록 한다
          isAlwaysShown: true,
          thickness: 15,
          child: ListView(
            controller: _scrollController,
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            children: [
              Column(
                children: [
                  // 매장 이름
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      '${_shopData.shopName}(관리자)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  // 매장 정보 변경
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Image.network(
                              'https://picsum.photos/250?image=9')),
                      // TextFiled로 내용 수정 가능
                      Container(
                        width: 100,
                        height: 100,
                        child: TextField(
                          controller: _InformationTextEdit,
                          decoration: InputDecoration(
                            // icon: Icon(Icons.shop),
                            border: OutlineInputBorder(),
                            labelText: "소개글",
                          ),
                          onChanged: (text) {
                            _shopData.changeInfo(_InformationTextEdit.text);
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            print('description : $description');
                          },
                          child: Text('저장'))
                    ],
                  ),

                  // 테이블 별 게임 중 or 게임 대기중 / Open / Closed
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    height: 250,
                    width: 200,
                    child: Column(
                      children: [
                        // 게임 진행여부 판단
                        Column(
                          children: [
                            RadioListTile(
                              title: Text('게임중'),
                              // InGame
                              value: "InGame",
                              groupValue: _gameTableFlag,
                              onChanged: (value) {
                                setState(() {
                                  _gameTableFlag = value.toString();
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text('게임 대기중'),
                              // InGame
                              value: "Waiting",
                              groupValue: _gameTableFlag,
                              onChanged: (value) {
                                setState(() {
                                  _gameTableFlag = value.toString();
                                });
                              },
                            )
                          ],
                        ),
                        // 매장 오픈 / 마감 여부
                        Column(
                          children: [
                            RadioListTile(
                              title: Text('Open'),
                              // InGame
                              value: "Open",
                              groupValue: _shopFlag,
                              onChanged: (value) {
                                setState(() {
                                  _shopFlag = value.toString();
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text('마감'),
                              // InGame
                              value: "Closed",
                              groupValue: _shopFlag,
                              onChanged: (value) {
                                setState(() {
                                  _shopFlag = value.toString();
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 주소 입력 => 지도로 변환
                  Container(

                    
                  ),


                  // 예약인원 설정 및 현재인원 설정 버튼
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopManageSetting()),
                              );
                            },
                            child: Text('게임 예약 설정')),

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
                    child: Column(
                      children: [
                        Text(
                          '대기 인원 (${ReserveUser.length})',
                          style: TextStyle(fontSize: 18),
                        ),
                        // 관리자 직접 예약자 추가
                        IconButton(
                            onPressed: () {
                              _shopData.reserve_increment();
                              setState(() {
                                // ReserveUser
                                ReserveUser.add(temp);
                              });
                            },
                            icon: Icon(Icons.add)),
                        Container(
                          height: 400,
                          child: new ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: ReserveUser.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new ListTile(
                                onTap: () {
                                  print(ReserveUser.runtimeType);
                                  _showMaterialDialog(
                                      ReserveUser[index], index);
                                },
                                leading: Icon(Icons.person),
                                title: Text(
                                    ReserveUser[index]['nickname'].toString()),
                                subtitle:
                                    Text(ReserveUser[index]['name'].toString()),
                                trailing: Text(ReserveUser[index]['phonenumber']
                                    .toString()),
                              );
                            },
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
                    child: Column(
                      children: [
                        Text(
                          '현재인원 (${GameUser.length})',
                          style: TextStyle(fontSize: 18),
                        ),
                        // 사용자 현재인원 직접 추가
                        IconButton(
                            onPressed: () {
                              _shopData.now_increment();
                              setState(() {
                                // GameUser
                                GameUser.add(temp);
                              });
                            },
                            icon: Icon(Icons.add)),
                        Container(
                          height: 400,
                          child: new ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: GameUser.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new ListTile(
                                leading: Icon(Icons.person),
                                title: Text(
                                    GameUser[index]['nickname'].toString()),
                                subtitle:
                                    Text(GameUser[index]['name'].toString()),
                                trailing: Text(
                                    GameUser[index]['phonenumber'].toString()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
