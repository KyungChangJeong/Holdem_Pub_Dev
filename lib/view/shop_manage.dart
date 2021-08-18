import 'package:flutter/material.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:holdem_pub/view/shop_manage_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'game_reserve_list.dart';

class ShopManage extends StatefulWidget {
  const ShopManage({Key? key}) : super(key: key);

  @override
  _ShopManageState createState() => _ShopManageState();
}

var ReserveUser = [];
var GameUser = [];
var GameList = [];

class GameListData {
  late String reserveNum;
  late String time;

  GameListData(this.reserveNum, this.time);
}

class _ShopManageState extends State<ShopManage> {
  // Radio ListTile구현
  String _gameTableFlag = 'Waiting';
  String _shopFlag = 'Closed';

  // 직접입력 데이터
  String temp = '이름없음';

  // 바 컨트롤러 생성
  final ScrollController _scrollController = ScrollController();

  // 소개글 수정 컨트롤러
  final _InformationTextEdit = TextEditingController();

  // Dialog 이름 컨트롤러
  final _dialogtextFieldController = TextEditingController();

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;


  @override
  void dispose() {
    _InformationTextEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);

    // SnackBar
    void _showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    }

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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Image.network(
                                    'https://picsum.photos/250?image=9')),
                            // TextFiled로 내용 수정 가능
                            Container(
                              width: 300,
                              child: TextFormField(
                                initialValue: _shopData.getInfo(),
                                // controller: _InformationTextEdit,
                                decoration: InputDecoration(
                                  // icon: Icon(Icons.shop),
                                  border: OutlineInputBorder(),
                                  labelText: "소개글",
                                ),
                                onChanged: (text) {
                                  _shopData.changeInfo(text);
                                },
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  CollectionReference users = FirebaseFirestore
                                      .instance
                                      .collection('users');
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
                                          builder: (context) =>
                                              ShopManageSetting()),
                                    );
                                  },
                                  child: Text('게임 예약 설정')),
                            ],
                          ),
                        ),

                        // 생성된 게임 목록
                        // shop_manage_setting에서 값 변경시 shop_manage화면에 즉시 변경 안됨
                        // 해결방법 => Firebase DB에서 값 추가를 snapshot으로 읽어 빌드
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text('생성 게임 목록'),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Shop')
                                      .doc('jackpotrounge')
                                      .collection('Games')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Text("생성된 게임이 없습니다!");
                                    return Container(
                                      height: 300,
                                      child: new ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            child: new ListTile(
                                              onTap: () {
                                                // 예약자 목록 / 현재 목록 설정으로 이동
                                                // Navigator
                                              },
                                              leading: Icon(Icons.games),
                                              // DB 문서 이름
                                              title: Text(
                                                  "${snapshot.data!.docs[index].get('게임이름')}"),
                                              subtitle: Text(
                                                  '${snapshot.data!.docs[index].get('게임시작시간')}'),
                                              trailing: Container(
                                                child: Text(
                                                    "예약 가능 인원 : ${snapshot.data!.docs[index].get('게임가능인원')}"),
                                              ),
                                            ),

                                            /// 오른쪽 슬라이더블
                                            secondaryActions: <Widget>[
                                              IconSlideAction(
                                                  caption: '예약관리',
                                                  color: Colors.black45,
                                                  icon: Icons.move_to_inbox,
                                                  onTap: () {
                                                    _showSnackBar(context, '예약 관리');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GameReserveList(
                                                                GameId:
                                                                    " ${snapshot.data!.docs[index].id}",

                                                              )),
                                                    );
                                                  }),
                                              IconSlideAction(
                                                  caption: '정보수정',
                                                  color: Colors.blue,
                                                  icon: Icons.update,
                                                  onTap: () {
                                                    _showSnackBar(
                                                        context, '게임 정보 수정');
                                                    firestoreInstance
                                                        .collection('Shop')
                                                        // 가게이름
                                                        .doc('jackpotrounge')
                                                        // 게임별 인덱스 설정
                                                        .collection('Games')
                                                        .doc(
                                                            '${snapshot.data!.docs[index].id}')
                                                        .update({
                                                      "게임시작시간": "19:00",
                                                    });
                                                  }),
                                              IconSlideAction(
                                                  caption: '삭제',
                                                  color: Colors.red,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    // _showSnackBar(context, '정보 수정');
                                                    _showSnackBar(context,
                                                        "${snapshot.data!.docs[index].id}");

                                                    firestoreInstance
                                                        .collection('Shop')
                                                        // 가게이름
                                                        .doc('jackpotrounge')
                                                        // 게임별 인덱스 설정
                                                        .collection('Games')
                                                        .doc(
                                                            '${snapshot.data!.docs[index].id}')
                                                        .delete();
                                                  }),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}


// void _showMaterialDialog(String status, int index) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('상태 변경'),
//           actions: <Widget>[
//             TextButton(
//                 onPressed: () {
//                   // 예약 => 게임
//                   setState(() {
//                     // ReserveUser에서 status 삭제
//                     ReserveUser.removeAt(index);
//                     _shopData.reserve_decrement();
//
//                     // GameUser에 status 추가
//                     GameUser.add(status);
//                     _shopData.game_increment();
//                   });
//
//                   Navigator.pop(context);
//                 },
//                 child: Text('수락')),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('취소'),
//             )
//           ],
//         );
//       });
// }
//
// void _reserveAddUserDialog() async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('대기 명단 추가'),
//           content: TextField(
//             controller: _dialogtextFieldController,
//             textInputAction: TextInputAction.go,
//             decoration: InputDecoration(hintText: "사용자 이름"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('추가'),
//               onPressed: () {
//                 // ReserveUser
//                 temp = _dialogtextFieldController.text;
//                 firestoreInstance
//                     .collection('Shop')
//                     // 가게이름
//                     .doc('jackpotrounge')
//                     // 게임별 인덱스 설정
//                     .collection('Games')
//                     .doc('Game1')
//                     .collection('ReserveList')
//                     .doc('$temp')
//                     .set({
//                   "name": "$temp",
//                 }).then((value) => print('예약자 DB 저장 성공'));
//
//                 setState(() {
//                   _shopData.reserve_increment();
//                   ReserveUser.add(temp);
//                 });
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }
//
// void _reserveUpdateUserDialog(int index) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('대기자 명단 수정'),
//           content: TextField(
//             controller: _dialogtextFieldController,
//             textInputAction: TextInputAction.go,
//             decoration: InputDecoration(hintText: "사용자 이름"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('수정'),
//               onPressed: () {
//                 // ReserveUser
//                 temp = _dialogtextFieldController.text;
//
//                 /// 수정 에러 발생
//                 /// doc에서 이름을 한번 변경시 추적이 안되는 문제 발생
//                 // firestoreInstance
//                 //     .collection('Shop')
//                 //     // 가게이름
//                 //     .doc('jackpotrounge')
//                 //     // 게임별 인덱스 설정
//                 //     .collection('Games')
//                 //     .doc('Game1')
//                 //     .collection('ReserveList')
//                 //     .doc('${ReserveUser[index]}')
//                 //     .update({
//                 //   "name": "$temp",
//                 // }).then((value) => print('예약자 DB 저장 성공'));
//                 setState(() {
//                   ReserveUser[index] = temp;
//                 });
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }
//
// void _nowUserAddDialog() async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('게임 명단 추가'),
//           content: TextField(
//             controller: _dialogtextFieldController,
//             textInputAction: TextInputAction.go,
//             decoration: InputDecoration(hintText: "사용자 이름"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('추가'),
//               onPressed: () {
//                 // GameUser
//                 temp = _dialogtextFieldController.text;
//
//                 /// DB 저장
//                 firestoreInstance
//                     .collection('Shop')
//                     // 가게이름
//                     .doc('jackpotrounge')
//                     // 게임별 인덱스 설정
//                     .collection('Games')
//                     .doc('Game1')
//                     .collection('GameList')
//                     .doc('$temp')
//                     .set({
//                   "name": "$temp",
//                 }).then((value) => print('게임 인원 저장'));
//                 setState(() {
//                   _shopData.game_increment();
//                   GameUser.add(temp);
//                 });
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }
//
// void _nowUserUpdateUserDialog(int index) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('현재 명단 수정'),
//           content: TextField(
//             controller: _dialogtextFieldController,
//             textInputAction: TextInputAction.go,
//             decoration: InputDecoration(hintText: "사용자 이름"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('수정'),
//               onPressed: () {
//                 // ReserveUser
//                 temp = _dialogtextFieldController.text;
//
//                 /// 수정 에러 발생
//                 /// doc에서 이름을 한번 변경시 추적이 안되는 문제 발생
//                 // firestoreInstance
//                 //     .collection('Shop')
//                 //     // 가게이름
//                 //     .doc('jackpotrounge')
//                 //     // 게임별 인덱스 설정
//                 //     .collection('Games')
//                 //     .doc('Game1')
//                 //     .collection('GameList')
//                 //     .doc('${GameUser[index]}')
//                 //     .update({
//                 //   "name": "$temp",
//                 // }).then((value) => print('게임인원 변경'));
//                 setState(() {
//                   GameUser[index] = temp;
//                 });
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }