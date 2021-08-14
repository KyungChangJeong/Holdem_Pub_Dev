import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holdem_pub/view/shop_manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopManageSetting extends StatefulWidget {
  const ShopManageSetting({Key? key}) : super(key: key);

  @override
  _ShopManageSettingState createState() => _ShopManageSettingState();
}

class _ShopManageSettingState extends State<ShopManageSetting> {

  final firestoreInstance = FirebaseFirestore.instance;
  final _reserve_people = TextEditingController();
  String _selectedTime='';
  late int gameIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 예약 생성'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // 예약가능 인원
            Container(
              child: Column(
                children: [
                  Text('예약가능 인원'),
                  Container(
                    /// 10 이하의 숫자 만 입력 가능하도록 설정
                    child: TextField(
                      controller: _reserve_people,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: '예약 가능인원 설정',
                        hintText: '8명',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 게임 시작시간
            Container(
              child: Column(
                children: [
                  Text('게임 시작 시간 설정',style: TextStyle(fontSize: 20),),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Future<TimeOfDay?> selectedTime = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              selectedTime.then((timeOfDay) {
                                setState(() {
                                  _selectedTime =
                                      '${timeOfDay!.hour}:${timeOfDay.minute}';
                                  print('_selectedTime : $_selectedTime');
                                });
                              });
                            },
                            child: Text('시작 시간 설정')),
                          (_selectedTime =="") ? Text('게임 시작 시간 설정하세요') : Text('게임 시작 시간 : $_selectedTime'),


                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(),

            // 예약 설정 활성화 버튼
            Container(
              child: TextButton(
                child: Text('게임 활성화'),
                onPressed: ()  {

                  // 게임 몇개 설정되있는지
                  firestoreInstance.collection('Shop').doc('jackpotrounge').get().then((value) {
                    gameIndex = (value.data())!['gameSetting'];
                    print('gameIndex : $gameIndex');
                  },);
                  gameIndex++;
                  
                  // 설정된 게임 수 DB 저장
                  firestoreInstance
                      .collection('Shop')
                      .doc('jackpotrounge')
                      .update({
                    "gameSetting": gameIndex,
                  });
                  
                  // 게임 추가 설정
                  firestoreInstance
                      .collection('Shop')
                      .doc('jackpotrounge')
                      .collection('Games')
                      .doc('Game$gameIndex')
                      .set({
                    "게임인원": _reserve_people.text,
                    "게임시작시간" :_selectedTime,
                  });

                 


                  //게임 추가
                  GameList.add(
                      GameListData(_reserve_people.text ,_selectedTime)
                  );
                  // 데이터 값 넘겨주기
                  Navigator.pop(context,true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
