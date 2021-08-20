import 'dart:core';
import 'package:flutter/material.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShopInformation extends StatefulWidget {
  @override
  _ShopInformationState createState() => _ShopInformationState();
}

// Javascript Key
const String kakaoMapKey = 'e281adbe18c6cce0487f2be5167a487c';

// 페이지 이동시 예약을 했음에도 false로 변경되는 상황
// DB에 넣든지, local data에 저장하던지 방법을 변경해야함
bool game_set_flag = false;
bool game_reserve_flag = false;

class _ShopInformationState extends State<ShopInformation> {
  int reservation_people = 2;
  int now_people = 4;

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

    /// 예약 확인차
    void showAlertDialog(String gameName) async {
      String result = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('예약'),
            content: game_reserve_flag
                ? Text("예약을 취소 하시겠습니까?")
                : Text("7:30분 게임에 예약하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                  setState(() {
                    // 예약 취소 상태
                    if (game_reserve_flag) {
                      /// DB 사용자 예약 정보 삭제
                      firestoreInstance
                          .collection('Shop')
                          .doc('jackpotrounge')
                          .collection('Games')
                          .doc('$gameName')
                          .collection('ReserveList')
                          // 사용자 이름 넣기
                          .doc('사용자예약')
                          .delete()
                          .then((_) {
                        /// 예약인원수 변경(삭제)
                        firestoreInstance
                            .collection('Shop')
                            // 가게이름
                            .doc('jackpotrounge')
                            // 게임별 인덱스 설정
                            .collection('Games')
                            .doc('$gameName')
                            .collection('ReserveList')
                            .get()
                            .then((value) {
                          firestoreInstance
                              .collection('Shop')
                              // 가게이름
                              .doc('jackpotrounge')
                              // 게임별 인덱스 설정
                              .collection('Games')
                              .doc('$gameName')
                              .update({
                            "예약인원": value.docs.length,
                          });
                        });
                      });
                    }

                    // 예약 하기 상태
                    else {
                      /// DB 사용자의 예약 정보 등록하기
                      // 사용자 예약
                      firestoreInstance
                          .collection('Shop')
                          .doc('jackpotrounge')
                          .collection('Games')
                          .doc('$gameName')
                          .collection('ReserveList')
                          // 사용자 이름 넣기
                          .doc('사용자예약')
                          .set({
                        "name": '사용자예약',
                      }).then((_) {
                        /// 예약인원수 변경(추가)
                        firestoreInstance
                            .collection('Shop')
                            // 가게이름
                            .doc('jackpotrounge')
                            // 게임별 인덱스 설정
                            .collection('Games')
                            .doc('$gameName')
                            .collection('ReserveList')
                            .get()
                            .then((value) {
                          firestoreInstance
                              .collection('Shop')
                              // 가게이름
                              .doc('jackpotrounge')
                              // 게임별 인덱스 설정
                              .collection('Games')
                              .doc('$gameName')
                              .update({
                            "예약인원": value.docs.length,
                          });
                        });
                      });
                    }
                    game_reserve_flag = !game_reserve_flag;
                  });
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, "Cancel");
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('매장 상세정보'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  // 선택한 리스트 ID 메인에서 넘기기 => isEqualTo 값 넣어주기
                  .collection('Shop')
                  .where('shop_name', isEqualTo: "jackpotrounge")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text("게임 정보가 없습니다.");
                return Column(
                  children: [
                    Container(
                      width: 200,
                      height: 100,
                      // 매장 이름
                      child: Center(
                          child: Text(
                        '${snapshot.data!.docs[0].get('shop_name')}(사용자)',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      // 로고 /  소개글
                      child: Column(
                        children: [
                          // Storage 이미지 저장 => FireStore 이미지 경로
                          // Image
                          Image.network(
                              '${snapshot.data!.docs[0].get('shop_logo')}'),
                          Text(
                              '소개글 : ${snapshot.data!.docs[0].get('shop_info')}'),
                        ],
                      ),
                    ),
                    Container(
                      // 게임중 / 대기중 / 오픈 / 마감 화면
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 게임중 / 게임 대기중
                          game_set_flag ? Text('게임중') : Text('게임 대기중'),

                          // 오픈 or 마감
                          Icon(Icons.fire_extinguisher),
                        ],
                      ),
                    ),
                    Container(
                      child: new ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Shop')
                                  // 가게이름
                                  .doc('jackpotrounge')
                                  // 게임별 인덱스 설정
                                  .collection('Games')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("게임 정보가 없습니다.");
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // 게임 리스트 출력
                                      Text(
                                        '게임 리스트',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height: 200,
                                        child: new ListView.builder(
                                            padding: EdgeInsets.all(8),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Slidable(
                                                  actionPane:
                                                      SlidableDrawerActionPane(),
                                                  actionExtentRatio: 0.25,
                                                  child: new ListTile(
                                                    leading:
                                                        Icon(Icons.games_sharp),
                                                    title: Text(
                                                        '${snapshot.data!.docs[index].get('게임이름')}'),
                                                    subtitle: Text(
                                                        '${snapshot.data!.docs[index].get('게임시작시간')}'),
                                                    trailing: Column(
                                                      children: [
                                                        Text(
                                                            '${snapshot.data!.docs[index].get('예약인원')}/ ${snapshot.data!.docs[index].get('게임대기인원')}'),
                                                        // firestoreInstance.collection('Shop').doc('jackpotrounge').collection('Games').doc('${snapshot.data!.docs[index].get('게임이름')}').collection('ReserveList').where('name',isEqualTo: "사용자예약")
                                                        if(false)
                                                          Text(
                                                              '예약 됨',style: TextStyle(color: Colors.red),),
                                                      ],
                                                    ),
                                                  ),
                                                  secondaryActions: <Widget>[
                                                    game_reserve_flag
                                                        ?
                                                    IconSlideAction(
                                                        caption: '예약취소',
                                                        color: Colors.red,
                                                        icon:
                                                            Icons.move_to_inbox,
                                                        onTap: () {
                                                          _showSnackBar(
                                                              context, '예약 취소');
                                                          showAlertDialog(snapshot
                                                              .data!
                                                              .docs[
                                                          index]
                                                              .get(
                                                              '게임이름'));

                                                        })
                                                    :
                                                    IconSlideAction(
                                                        caption: '예약하기',
                                                        color: Colors.blue,
                                                        icon:
                                                        Icons.move_to_inbox,
                                                        onTap: () {
                                                          _showSnackBar(
                                                              context, '예약 하기');
                                                          showAlertDialog(snapshot
                                                              .data!
                                                              .docs[
                                                          index]
                                                              .get(
                                                              '게임이름'));
                                                        }),

                                                    IconSlideAction(
                                                        caption: '예약 현황 확인',
                                                        color: Colors.black,
                                                        icon: Icons.update,
                                                        onTap: () {
                                                          _showSnackBar(context,
                                                              '예약 현황 확인');

                                                        }),
                                                  ]);
                                            }),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),

                    // 현재인원 / 예약자
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text('예약인원 : ${_shopData.getReserveNum()}명'),
                    //           game_reserve_flag
                    //               ? Text(
                    //                   '  예약됨',
                    //                   style: TextStyle(
                    //                     color: Colors.red,
                    //                   ),
                    //                 )
                    //               : Text(''),
                    //         ],
                    //       ),
                    //       Text('현재인원 : ${_shopData.getGameNum()}명'),
                    //     ],
                    //   ),
                    // ),

                    // 지도 WebView

                    Container(
                      // 매장 위치
                      child: Column(
                        children: [
                          // https://pub.dev/packages/kakaomap_webview
                          KakaoMapView(
                              // 마커이름 표시
                              overlayText: '사무실',
                              width: 300,
                              height: 200,
                              kakaoMapKey: kakaoMapKey,
                              // 좌표 설정
                              // lat: ShopLocation.latitude,
                              // lng: ShopLocation.longitude,
                              lat: snapshot.data!.docs[0]
                                  .get('location')
                                  .latitude,
                              lng: snapshot.data!.docs[0]
                                  .get('location')
                                  .longitude,
                              showMapTypeControl: true,
                              showZoomControl: false,
                              markerImageURL:
                                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                              onTapMarker: (message) async {}),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     game_reserve_flag
                    //         ?
                    //         // 예약 취소
                    //         TextButton(
                    //             onPressed: () {
                    //               // 예약 취소 창
                    //               showAlertDialog(context);
                    //             },
                    //             child: Text('취소하기'))
                    //         :
                    //         // 예약 하기
                    //         TextButton(
                    //             onPressed: () {
                    //               // 예약 확인 창
                    //               showAlertDialog(context);
                    //             },
                    //             child: Text('예약하기')),
                    //     TextButton(
                    //         onPressed: () {
                    //           // 채팅 페이지로
                    //         },
                    //         child: Text('채팅'))
                    //   ],
                    // ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
