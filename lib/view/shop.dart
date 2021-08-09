import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

class ShopInformation extends StatefulWidget {
  @override
  _ShopInformationState createState() => _ShopInformationState();
}

class _ShopInformationState extends State<ShopInformation> {
  int reservation_people = 2;
  int now_people = 4;

  static const String kakaoMapKey = '3ed12adaf33fb0a80dbaf44f6983027f';

  // late KakaoMapController mapController;
  // MapPoint _visibleRegion = MapPoint(37.5087553, 127.0632877);
  // CameraPosition _kInitialPosition =
  // CameraPosition(target: MapPoint(37.5087553, 127.0632877), zoom: 5);
  //
  // void onMapCreated(KakaoMapController controller) async {
  //   final MapPoint visibleRegion = await controller.getMapCenterPoint();
  //   setState(() {
  //     mapController = controller;
  //     _visibleRegion = visibleRegion;
  //   });
  // }
  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();

    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
    String url =
    await util.getMapScreenURL(37.402056, 127.108212, name: 'Kakao 본사');

  }
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
                    lat: 33.450701,
                    lng: 126.570667,
                    showMapTypeControl: true,
                    showZoomControl: true,
                    markerImageURL:
                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                    onTapMarker: (message) async {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Marker is clicked')));
                      await _openKakaoMapScreen(context);
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
