import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

class ShopInformation extends StatefulWidget {
  @override
  _ShopInformationState createState() => _ShopInformationState();
}
// Javascript Key
 const String kakaoMapKey = 'e281adbe18c6cce0487f2be5167a487c';

class _ShopInformationState extends State<ShopInformation> {
  int reservation_people = 2;
  int now_people = 4;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('매장 상세정보'),
      ),
      body: Column(
        children: [
          Container(
            // 매장 이름
            child: Text('매장1'),
          ),
          Container(
            // 로고 /  소개글
            child: Row(
              children: [
                // Storage 이미지 저장 => FireStore 이미지 경로
                // Image
                Icon(Icons.paid_rounded),
                Text('소개글 ~~~~~~~~~~~~~~~'),
              ],
            ),

          ),
          Container(
            // 현재인원 / 예약자
            child: Column(
              children: [
                Text('예약인원 : $reservation_people명'),
                Text('현재인원 : $now_people명'),
              ],
            ),
          ),
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
                    onTapMarker: (message) async {
                    }),

              ],
            ),

          ),
          TextButton(onPressed: (){
            // 예약 인원 ++
            // 취소 버튼으로 변경
          }, child: Text('예약하기')),

          TextButton(onPressed: (){
            // 채팅 페이지로
          }, child: Text('채팅'))

        ],

      ),

    );
  }
}
