import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:provider/provider.dart';

class ShopInformation extends StatefulWidget {
  @override
  _ShopInformationState createState() => _ShopInformationState();
}

// Javascript Key
const String kakaoMapKey = 'e281adbe18c6cce0487f2be5167a487c';

class _ShopInformationState extends State<ShopInformation> {
  int reservation_people = 2;
  int now_people = 4;

  // 페이지 이동시 예약을 했음에도 false로 변경되는 상황
  // DB에 넣든지, local data에 저장하던지 방법을 변경해야함
  bool game_set_flag = false;
  bool game_reserve_flag = false;



  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);

    void showAlertDialog(BuildContext context) async {
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
                    if(game_reserve_flag){
                      _shopData.reserve_decrement();
                    }
                    // 예약 하기 상태
                    else{
                      _shopData.reserve_increment();
                      /// DB 사용자의 예약 정보 등록하기
                      // FireStore
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
          Container(
            width: 200,
            height: 100,
            // 매장 이름
            child: Center(
                child: Text(
              '${_shopData.shopName}(사용자)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
          ),
          Container(
            // 로고 /  소개글
            child: Column(
              children: [
                // Storage 이미지 저장 => FireStore 이미지 경로
                // Image
                Image.network('https://picsum.photos/250?image=9'),
                Text('소개글 : ${_shopData.getInfo()}'),
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
            // 현재인원 / 예약자
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('예약인원 : ${_shopData.getReserveNum()}명'),
                    game_reserve_flag ? Text('  예약됨', style: TextStyle(
                      color: Colors.red,
                    ),) : Text(''),
                  ],
                ),
                Text('현재인원 : ${_shopData.getNowNum()}명'),
              ],
            ),
          ),
          // 지도 WebView
          Container(
            // 매장 위치
            child: Column(
              children: [
                // https://pub.dev/packages/kakaomap_webview
                KakaoMapView(
                    width: 300,
                    height: 200,
                    kakaoMapKey: kakaoMapKey,
                    // 좌표 설정
                    lat: 33.450701,
                    lng: 126.570667,
                    showMapTypeControl: true,
                    // showZoomControl: true,
                    markerImageURL:
                        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                    onTapMarker: (message) async {}),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              game_reserve_flag
                  ?
                  // 예약 취소
                  TextButton(
                      onPressed: () {
                        // 예약 취소 창
                        showAlertDialog(context);
                      },
                      child: Text('취소하기'))
                  :
                  // 예약 하기
                  TextButton(
                      onPressed: () {
                        // 예약 확인 창
                        showAlertDialog(context);
                      },
                      child: Text('예약하기')),
              TextButton(
                  onPressed: () {
                    // 채팅 페이지로
                  },
                  child: Text('채팅'))
            ],
          ),
        ],
      ),
    );
  }
}
