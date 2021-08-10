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

  DateTime _dateTime = DateTime.now();
  /// SAMPLE
  Widget hourMinute12H(){
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinuteSecond(){
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinute15Interval(){
    return new TimePickerSpinner(
      spacing: 40,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinute12HCustomStyle(){
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.deepOrange
      ),
      highlightedTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.yellow
      ),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        labelText: 'Type your Number',
                        hintText: '4명',
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
                  Text('게임 시작 시간'),
                  new Container(
                    padding: EdgeInsets.only(
                        top: 100
                    ),
                    child: new Column(
                      children: <Widget>[
//            hourMinute12H(),
                        hourMinute15Interval(),
//            hourMinuteSecond(),
//            hourMinute12HCustomStyle(),
                        new Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 50
                          ),
                          child: new Text(
                            _dateTime.hour.toString().padLeft(2, '0') + ':' +
                                _dateTime.minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),

                  )],

              ),
            ),
            // prise
            Container(),

            // 예약 설정 활성화 버튼
            Container(
              child: TextButton(
                child: Text('활성화'),
                onPressed: (){
                  print('reserve_people : ${_reserve_people.text.toString()}');
                  print('_dateTime : ${_dateTime.hour.toString()}:${_dateTime.minute.toString()}');
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
