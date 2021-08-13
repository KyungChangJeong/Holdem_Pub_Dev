import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class ShopManageSetting extends StatefulWidget {
  const ShopManageSetting({Key? key}) : super(key: key);

  @override
  _ShopManageSettingState createState() => _ShopManageSettingState();
}

class _ShopManageSettingState extends State<ShopManageSetting> {
  final _reserve_people = TextEditingController();
  String _selectedTime='';
  DateTime _dateTime = DateTime.now();

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
                                      '${timeOfDay!.hour}:${timeOfDay!.minute}';
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
                onPressed: () {
                  print('reserve_people : ${_reserve_people.text.toString()}');
                  print(
                      '_dateTime : ${_dateTime.hour.toString()}:${_dateTime.minute.toString()}');
                  // 데이터 값 넘겨주기
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
