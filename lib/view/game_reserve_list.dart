import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:holdem_pub/view/shop_manage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GameReserveList extends StatefulWidget {
  final String GameId;

  GameReserveList({Key? key, required this.GameId});

  @override
  _GameReserveListState createState() => _GameReserveListState();
}

class _GameReserveListState extends State<GameReserveList> {
  // 직접입력 데이터
  String temp = '이름없음';
  int reserveNum = 0;
  int gameNum = 0;

  // Dialog 이름 컨트롤러
  final _dialogtextFieldController = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  // SnackBar
  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);
    void _reserveAddUserDialog() async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('대기 명단 추가'),
              content: TextField(
                controller: _dialogtextFieldController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(hintText: "사용자 이름"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('추가'),
                  onPressed: () {
                    // ReserveUser
                    temp = _dialogtextFieldController.text;
                    // 명단 DB List에 값 넣기
                    /// 버그발견 문서이름.set으로하면 해당문서가 아닌 동적 문서가 생성되어 관리 어려움 발생
                    firestoreInstance
                        .collection('Shop')
                        // 가게이름
                        .doc('jackpotrounge')
                        // 게임별 인덱스 설정
                        .collection('Games')
                        .doc(widget.GameId)
                        .collection('ReserveList')
                        .doc(temp)
                        .set({
                      "name": "$temp",
                    }).then((value) => print('예약자 DB 저장 성공'));

                    //
                    // firestoreInstance
                    //     .collection('Shop')
                    // // 가게이름
                    //     .doc('jackpotrounge')
                    // // 게임별 인덱스 설정
                    //     .collection('Games')
                    //     .doc(widget.GameId)
                    //     .get().then((value) {
                    // print('value : ${value.data()}');
                    // });



                    // // 예약 + 버튼 눌렀을때 현재인원 변경
                    // reserveNum++;
                    // firestoreInstance
                    //     .collection('Shop')
                    // // 가게이름
                    //     .doc('jackpotrounge')
                    // // 게임별 인덱스 설정
                    //     .collection('Games')
                    //     .doc(widget.GameId)
                    //     .set({
                    //   '예약인원': reserveNum
                    // }).then((value) {
                    //   print("예약인원 reserveNum: $reserveNum");
                    // });


                    // firestoreInstance
                    //     .collection('Shop')
                    //     // 가게이름
                    //     .doc('jackpotrounge')
                    //     // 게임별 인덱스 설정
                    //     .collection('Games')
                    //     .add({
                    //   "예약인원": reserveNum,
                    // }).then((value) {
                    //   firestoreInstance
                    //       .collection('ReserveList')
                    //       .doc(temp)
                    //       .set({
                    //     "name": "$temp",
                    //   }).then((value) => print('예약자 DB 저장 성공'));
                    // });


                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _reserveUpdateUserDialog(int index) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('대기자 명단 수정'),
              content: TextField(
                controller: _dialogtextFieldController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(hintText: "사용자 이름"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('수정'),
                  onPressed: () {
                    // ReserveUser
                    temp = _dialogtextFieldController.text;

                    /// 수정 에러 발생
                    /// doc에서 이름을 한번 변경시 추적이 안되는 문제 발생
                    // firestoreInstance
                    //     .collection('Shop')
                    //     // 가게이름
                    //     .doc('jackpotrounge')
                    //     // 게임별 인덱스 설정
                    //     .collection('Games')
                    //     .doc('Game1')
                    //     .collection('ReserveList')
                    //     .doc('${ReserveUser[index]}')
                    //     .update({
                    //   "name": "$temp",
                    // }).then((value) => print('예약자 DB 저장 성공'));
                    setState(() {
                      ReserveUser[index] = temp;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _nowUserAddDialog() async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('게임 명단 추가'),
              content: TextField(
                controller: _dialogtextFieldController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(hintText: "사용자 이름"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('추가'),
                  onPressed: () {
                    // GameUser
                    temp = _dialogtextFieldController.text;

                    /// DB 저장
                    firestoreInstance
                        .collection('Shop')
                        // 가게이름
                        .doc('jackpotrounge')
                        // 게임별 인덱스 설정
                        .collection('Games')
                        .doc(widget.GameId)
                        .collection('GameList')
                        .doc('$temp')
                        .set({
                      "name": "$temp",
                    }).then((value) => print('게임 인원 저장'));
                    setState(() {
                      _shopData.game_increment();
                      GameUser.add(temp);
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _nowUserUpdateUserDialog(int index) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('현재 명단 수정'),
              content: TextField(
                controller: _dialogtextFieldController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(hintText: "사용자 이름"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('수정'),
                  onPressed: () {
                    // ReserveUser
                    temp = _dialogtextFieldController.text;

                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('명단 관리'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // 예약자 현황
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Shop')
                        .doc('jackpotrounge')
                        .collection('Games')
                        .doc('${widget.GameId}')
                        .collection('ReserveList')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text("게임에 예약자가 없습니다.");
                      return Column(
                        children: [
                          Text(
                            '대기 인원 (${snapshot.data!.size})',
                            style: TextStyle(fontSize: 18),
                          ),

                          /// 관리자 직접 예약자 추가
                          IconButton(
                              onPressed: () {
                                // 대기인원 명단 작성
                                _reserveAddUserDialog();
                              },
                              icon: Icon(Icons.add)),

                          Container(
                            height: 300,
                            child: new ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: new ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                        snapshot.data!.docs[index].get('name')),
                                  ),

                                  /// 오른쪽 슬라이더블
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                        caption: '상태 변경',
                                        color: Colors.black45,
                                        icon: Icons.move_to_inbox,
                                        onTap: () {
                                          _showSnackBar(context, '현재 인원으로');

                                          // GameUser에 status 추가
                                          firestoreInstance
                                              .collection('Shop')
                                              // 가게이름
                                              .doc('jackpotrounge')
                                              // 게임별 인덱스 설정
                                              .collection('Games')
                                              .doc('${widget.GameId}')
                                              .collection('GameList')
                                              .doc(
                                                  '${snapshot.data!.docs[index].get('name')}')
                                              .set({
                                            "name":
                                                "${snapshot.data!.docs[index].get('name')}"
                                          }).then((_) => print('대기 인원 삭제'));

                                          // ReserveUser에서 삭제
                                          firestoreInstance
                                              .collection('Shop')
                                              // 가게이름
                                              .doc('jackpotrounge')
                                              // 게임별 인덱스 설정
                                              .collection('Games')
                                              .doc('${widget.GameId}')
                                              .collection('ReserveList')
                                              .doc(
                                                  '${snapshot.data!.docs[index].get('name')}')
                                              .delete()
                                              .then((_) => print('대기 인원 삭제'));
                                        }),
                                    IconSlideAction(
                                        caption: '정보수정',
                                        color: Colors.blue,
                                        icon: Icons.update,
                                        onTap: () {
                                          _showSnackBar(context, '정보 수정');
                                          _reserveUpdateUserDialog(index);
                                        }),
                                    IconSlideAction(
                                        caption: '삭제',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          _showSnackBar(context, '삭제');
                                          firestoreInstance
                                              .collection('Shop')
                                              // 가게이름
                                              .doc('jackpotrounge')
                                              // 게임별 인덱스 설정
                                              .collection('Games')
                                              .doc(widget.GameId)
                                              .collection('ReserveList')
                                              .doc(
                                                  '${snapshot.data!.docs[index].get('name')}')
                                              .delete()
                                              .then((_) => print('대기 인원 삭제'));
                                        }),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
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
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Shop')
                            .doc('jackpotrounge')
                            .collection('Games')
                            .doc('${widget.GameId}')
                            .collection('GameList')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Text("게임에 게임대기자가 없습니다.");
                          return Column(
                            children: [
                              Text(
                                '현재인원 (${snapshot.data!.size})',
                                style: TextStyle(fontSize: 18),
                              ),
                              // 사용자 현재인원 직접 추가
                              IconButton(
                                  onPressed: () {
                                    _nowUserAddDialog();
                                  },
                                  icon: Icon(Icons.add)),
                              Container(
                                height: 300,
                                child: new ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.25,
                                      child: new ListTile(
                                        leading: Icon(Icons.person),
                                        title: Text(snapshot.data!.docs[index]
                                            .get('name')),
                                      ),

                                      /// 오른쪽 슬라이더블
                                      secondaryActions: <Widget>[
                                        IconSlideAction(
                                            caption: '정보수정',
                                            color: Colors.blue,
                                            icon: Icons.update,
                                            onTap: () {
                                              _showSnackBar(context, '정보 수정');
                                              _nowUserUpdateUserDialog(index);
                                            }),
                                        IconSlideAction(
                                            caption: '삭제',
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () {
                                              _showSnackBar(context, '삭제');
                                              firestoreInstance
                                                  .collection('Shop')
                                                  // 가게이름
                                                  .doc('jackpotrounge')
                                                  // 게임별 인덱스 설정
                                                  .collection('Games')
                                                  .doc('${widget.GameId}')
                                                  .collection('GameList')
                                                  .doc(
                                                      '${snapshot.data!.docs[index].get('name')}')
                                                  .delete()
                                                  .then(
                                                      (_) => print('게임 인원 삭제'));
                                              GameUser.removeAt(index);
                                              _shopData.game_decrement();
                                            }),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // 게임 시작 버튼
                              TextButton(
                                  onPressed: () {
                                    // 1. 상태 플래그 변화(DB -> {Games => 해당 게임 Flag변화})
                                    // 2. 예약 신청 못하게 표시
                                    // 3. 사용자 화면에서 변하게 변경
                                  },
                                  child: Text(
                                    '게임 시작',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ))
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
