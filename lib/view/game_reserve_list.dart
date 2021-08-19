import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:holdem_pub/view/shop_manage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GameReserveList extends StatefulWidget {
  final String GameId;

  GameReserveList({Key? key, required this.GameId}) : super(key: key);

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

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance
      .collection('Shop')
      .doc('jackpotrounge')
      .collection('Games');

  // SnackBar
  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);

    void _reserveAddUserDialog(int nowNum) async {
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
                    // 명단 DB ReserveList에 값 넣기
                    firestoreInstance
                        .collection('Shop')
                        .doc('jackpotrounge')
                        .collection('Games')
                        .doc('${widget.GameId.trim()}')
                        .collection('ReserveList')
                        .doc(temp)
                        .set({
                      "name": "$temp",
                    }).then((_) {
                      /// 예약인원수 변경(추가)
                      firestoreInstance
                          .collection('Shop')
                          // 가게이름
                          .doc('jackpotrounge')
                          // 게임별 인덱스 설정
                          .collection('Games')
                          .doc(widget.GameId.trim())
                          .collection('ReserveList')
                          .get()
                          .then((value) {
                        firestoreInstance
                            .collection('Shop')
                            // 가게이름
                            .doc('jackpotrounge')
                            // 게임별 인덱스 설정
                            .collection('Games')
                            .doc(widget.GameId.trim())
                            .update({
                          "예약인원": value.docs.length,
                        });
                      });
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _reserveUpdateUserDialog(String beforeName) async {
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

                    /// 여러번 수정 변경 가능
                    firestoreInstance
                        .collection('Shop')
                        // 가게이름
                        .doc('jackpotrounge')
                        // 게임별 인덱스 설정
                        .collection('Games')
                        .doc('${widget.GameId.trim()}')
                        // 변경 전 이름을 찾아서 정보 수정
                        .collection('ReserveList')
                        .where('name', isEqualTo: "$beforeName")
                        .get()
                        .then((value) {
                      firestoreInstance
                          .collection('Shop')
                          // 가게이름
                          .doc('jackpotrounge')
                          // 게임별 인덱스 설정
                          .collection('Games')
                          .doc('${widget.GameId.trim()}')
                          .collection('ReserveList')
                          .doc('${value.docs[0].id}')
                          .update({
                        "name": "$temp",
                      });
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
                    // GameList
                    temp = _dialogtextFieldController.text.trim();

                    /// GameList DB 저장
                    firestoreInstance
                        .collection('Shop')
                        // 가게이름
                        .doc('jackpotrounge')
                        // 게임별 인덱스 설정
                        .collection('Games')
                        .doc(widget.GameId.trim())
                        .collection('GameList')
                        .doc(temp.trim())
                        .set({
                      "name": "${temp.trim()}",
                    }).then((_) {
                      /// 게임대기인원수 변경(추가)
                      firestoreInstance
                          .collection('Shop')
                          // 가게이름
                          .doc('jackpotrounge')
                          // 게임별 인덱스 설정
                          .collection('Games')
                          .doc(widget.GameId.trim())
                          .collection('GameList')
                          .get()
                          .then((value) {
                        firestoreInstance
                            .collection('Shop')
                            // 가게이름
                            .doc('jackpotrounge')
                            // 게임별 인덱스 설정
                            .collection('Games')
                            .doc(widget.GameId.trim())
                            .update({
                          "게임대기인원": value.docs.length,
                        });
                      });
                    });

                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _nowUserUpdateUserDialog(String beforeName) async {
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
                    // GameList
                    temp = _dialogtextFieldController.text.trim();

                    firestoreInstance
                        .collection('Shop')
                        // 가게이름
                        .doc('jackpotrounge')
                        // 게임별 인덱스 설정
                        .collection('Games')
                        .doc('${widget.GameId.trim()}')
                        // 변경 전 이름을 찾아서 정보 수정
                        .collection('GameList')
                        .where('name', isEqualTo: "$beforeName")
                        .get()
                        .then((value) {
                      firestoreInstance
                          .collection('Shop')
                          // 가게이름
                          .doc('jackpotrounge')
                          // 게임별 인덱스 설정
                          .collection('Games')
                          .doc('${widget.GameId.trim()}')
                          .collection('GameList')
                          .doc('${value.docs[0].id}')
                          .update({
                        "name": "$temp",
                      });
                    });

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
                        .doc('${widget.GameId.trim()}')
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
                                _reserveAddUserDialog(snapshot.data!.size);
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

                                          /// GameList에 사용자 추가
                                          firestoreInstance
                                              .collection('Shop')
                                              // 가게이름
                                              .doc('jackpotrounge')
                                              // 게임별 인덱스 설정
                                              .collection('Games')
                                              .doc('${widget.GameId.trim()}')
                                              .collection('GameList')
                                              .doc(
                                                  '${snapshot.data!.docs[index].get('name')}')
                                              .set({
                                            "name":
                                                "${snapshot.data!.docs[index].get('name')}"
                                          }).then((_) {
                                            // 게임예약인원 수 변경
                                            firestoreInstance
                                                .collection('Shop')
                                                // 가게이름
                                                .doc('jackpotrounge')
                                                // 게임별 인덱스 설정
                                                .collection('Games')
                                                .doc(widget.GameId.trim())
                                                .collection('GameList')
                                                .get()
                                                .then((value) {
                                              firestoreInstance
                                                  .collection('Shop')
                                                  // 가게이름
                                                  .doc('jackpotrounge')
                                                  // 게임별 인덱스 설정
                                                  .collection('Games')
                                                  .doc(widget.GameId.trim())
                                                  .update({
                                                "게임대기인원": value.docs.length,
                                              });
                                            });
                                          });

                                          /// ReserveList에 사용자 삭제
                                          firestoreInstance
                                              .collection('Shop')
                                              // 가게이름
                                              .doc('jackpotrounge')
                                              // 게임별 인덱스 설정
                                              .collection('Games')
                                              .doc('${widget.GameId.trim()}')
                                              .collection('ReserveList')
                                              .doc(
                                                  '${snapshot.data!.docs[index].get('name')}')
                                              .delete()
                                              .then((_) {
                                            // 예약인원 수 변경(삭제)
                                            firestoreInstance
                                                .collection('Shop')
                                                // 가게이름
                                                .doc('jackpotrounge')
                                                // 게임별 인덱스 설정
                                                .collection('Games')
                                                .doc(widget.GameId.trim())
                                                .collection('ReserveList')
                                                .get()
                                                .then((value) {
                                              firestoreInstance
                                                  .collection('Shop')
                                                  // 가게이름
                                                  .doc('jackpotrounge')
                                                  // 게임별 인덱스 설정
                                                  .collection('Games')
                                                  .doc(widget.GameId.trim())
                                                  .update({
                                                "예약인원": value.docs.length,
                                              });
                                            });
                                          });
                                        }),
                                    IconSlideAction(
                                        caption: '정보수정',
                                        color: Colors.blue,
                                        icon: Icons.update,
                                        onTap: () {
                                          _showSnackBar(context, '정보 수정');
                                          _reserveUpdateUserDialog(
                                              '${snapshot.data!.docs[index].get('name')}');
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
                                              .doc(widget.GameId.trim())
                                              .collection('ReserveList')
                                              .where('name',
                                                  isEqualTo:
                                                      '${snapshot.data!.docs[index].get('name')}')
                                              .get()
                                              .then((value) {
                                            firestoreInstance
                                                .collection('Shop')
                                                // 가게이름
                                                .doc('jackpotrounge')
                                                // 게임별 인덱스 설정
                                                .collection('Games')
                                                .doc(widget.GameId.trim())
                                                .collection('ReserveList')
                                                .doc('${value.docs[0].id}')
                                                .delete();
                                          }).then((_) {
                                            /// 예약인원 수 변경(삭제)
                                            firestoreInstance
                                                .collection('Shop')
                                                // 가게이름
                                                .doc('jackpotrounge')
                                                // 게임별 인덱스 설정
                                                .collection('Games')
                                                .doc(widget.GameId.trim())
                                                .collection('ReserveList')
                                                .get()
                                                .then((value) {
                                              firestoreInstance
                                                  .collection('Shop')
                                                  // 가게이름
                                                  .doc('jackpotrounge')
                                                  // 게임별 인덱스 설정
                                                  .collection('Games')
                                                  .doc(widget.GameId.trim())
                                                  .update({
                                                "예약인원": value.docs.length,
                                              });
                                            });
                                          });
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
                            .doc('${widget.GameId.trim()}')
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
                                              _nowUserUpdateUserDialog(
                                                  '${snapshot.data!.docs[index].get('name')}');
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
                                                  .doc(
                                                      '${widget.GameId.trim()}')
                                                  .collection('GameList')
                                                  .where('name',
                                                      isEqualTo:
                                                          "${snapshot.data!.docs[index].get('name')}")
                                                  .get()
                                                  .then((value) {
                                                print(
                                                    '게임삭제 : ${value.docs[0].id}');
                                                firestoreInstance
                                                    .collection('Shop')
                                                    // 가게이름
                                                    .doc('jackpotrounge')
                                                    // 게임별 인덱스 설정
                                                    .collection('Games')
                                                    .doc(
                                                        '${widget.GameId.trim()}')
                                                    .collection('GameList')
                                                    .doc('${value.docs[0].id}')
                                                    .delete();
                                              }).then((_) {
                                                /// 게임예약인원 수 변경(삭제)
                                                firestoreInstance
                                                    .collection('Shop')
                                                    // 가게이름
                                                    .doc('jackpotrounge')
                                                    // 게임별 인덱스 설정
                                                    .collection('Games')
                                                    .doc(widget.GameId.trim())
                                                    .collection('GameList')
                                                    .get()
                                                    .then((value) {
                                                  firestoreInstance
                                                      .collection('Shop')
                                                      // 가게이름
                                                      .doc('jackpotrounge')
                                                      // 게임별 인덱스 설정
                                                      .collection('Games')
                                                      .doc(widget.GameId.trim())
                                                      .update({
                                                    "게임대기인원": value.docs.length,
                                                  });
                                                });
                                              });
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
