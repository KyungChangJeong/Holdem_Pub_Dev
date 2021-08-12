import 'package:flutter/material.dart';
import 'package:holdem_pub/model/ShopData.dart';
import 'package:holdem_pub/view/shop_manage_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShopManage extends StatefulWidget {
  const ShopManage({Key? key}) : super(key: key);

  @override
  _ShopManageState createState() => _ShopManageState();
}

var ReserveUser = [];
var GameUser = [];

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

  @override
  void initState() {}

  @override
  void dispose() {
    _InformationTextEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShopData _shopData = Provider.of<ShopData>(context);

    void _showMaterialDialog(String status, int index) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('상태 변경'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      // 예약 => 게임
                      setState(() {
                        // ReserveUser에서 status 삭제
                        ReserveUser.removeAt(index);
                        _shopData.reserve_decrement();

                        // GameUser에 status 추가
                        GameUser.add(status);
                        _shopData.game_increment();
                      });
                      print('대기인원 : ${ReserveUser}');
                      print('현재인원 : ${GameUser}');

                      Navigator.pop(context);
                    },
                    child: Text('수락')),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('취소'),
                )
              ],
            );
          });
    }

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
                    setState(() {
                      _shopData.reserve_increment();
                      ReserveUser.add(temp);
                    });
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
                    setState(() {
                      GameUser[index] = temp;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

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
          child: Expanded(
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
                        TextButton(onPressed: () {
                          CollectionReference users = FirebaseFirestore.instance.collection('users');


                        }, child: Text('저장'))
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

                    // 주소 입력 => 지도로 변환
                    Container(),

                    // slidable Test
                    Container(
                      // child:  Orientation,

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
                          // TextButton(onPressed: () {}, child: Text('현재 인원 설정')),
                        ],
                      ),
                    ),

                    // 예약자 현황
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '대기 인원 (${_shopData.getReserveNum()})',
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
                            height: 400,
                            child: new ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: ReserveUser.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: new ListTile(
                                    onTap: () {
                                      // _showMaterialDialog(
                                      //     ReserveUser[index], index);
                                    },
                                    leading: Icon(Icons.person),
                                    title: Text(ReserveUser[index].toString()),
                                  ),

                                  /// 왼쪽 슬라이더블
                                  // actions: <Widget>[
                                  //   IconSlideAction(
                                  //     caption: 'Archive',
                                  //     color: Colors.blue,
                                  //     icon: Icons.archive,
                                  //     onTap: () => _showSnackBar(context, 'Archive'),
                                  //   ),
                                  //   IconSlideAction(
                                  //     caption: 'Share',
                                  //     color: Colors.indigo,
                                  //     icon: Icons.share,
                                  //     onTap: () => _showSnackBar(context, 'Share'),
                                  //   ),
                                  // ],
                                  /// 오른쪽 슬라이더블
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                        caption: '상태 변경',
                                        color: Colors.black45,
                                        icon: Icons.move_to_inbox,
                                        onTap: () {
                                          _showSnackBar(context, '현재 인원으로');

                                          setState(() {
                                            // GameUser에 status 추가
                                            GameUser.add(ReserveUser[index]);
                                            // ReserveUser에서 status 삭제
                                            ReserveUser.removeAt(index);
                                            _shopData.reserve_decrement();
                                            _shopData.game_increment();
                                          });
                                        }
                                    ),
                                    IconSlideAction(
                                        caption: '정보수정',
                                        color: Colors.blue,
                                        icon: Icons.update,
                                        onTap: () {
                                          _showSnackBar(context, '정보 수정');
                                          _reserveUpdateUserDialog(index);
                                        }
                                    ),
                                    IconSlideAction(
                                      caption: '삭제',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: (){
                                        _showSnackBar(context, '삭제');
                                        ReserveUser.removeAt(index);
                                        _shopData.reserve_decrement();
                                      }
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
                          Text(
                            '현재인원 (${_shopData.getGameNum()})',
                            style: TextStyle(fontSize: 18),
                          ),
                          // 사용자 현재인원 직접 추가
                          IconButton(
                              onPressed: () {
                                _nowUserAddDialog();
                              },
                              icon: Icon(Icons.add)),
                          Container(
                            height: 400,
                            child: new ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: GameUser.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: new ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(GameUser[index].toString()),
                                    // subtitle:
                                    //     Text(GameUser[index].toString()),
                                    // trailing: Text(
                                    //     GameUser[index].toString()),
                                  ),
                                  /// 오른쪽 슬라이더블
                                  secondaryActions: <Widget>[
                                    // IconSlideAction(
                                    //     caption: '상태 변경',
                                    //     color: Colors.black45,
                                    //     icon: Icons.move_to_inbox,
                                    //     onTap: () {
                                    //       _showSnackBar(context, '현재 인원으로');
                                    //
                                    //       setState(() {
                                    //         // GameUser에 status 추가
                                    //         GameUser.add(ReserveUser[index]);
                                    //         // ReserveUser에서 status 삭제
                                    //         ReserveUser.removeAt(index);
                                    //         _shopData.reserve_decrement();
                                    //         _shopData.now_increment();
                                    //       });
                                    //     }
                                    // ),
                                    IconSlideAction(
                                        caption: '정보수정',
                                        color: Colors.blue,
                                        icon: Icons.update,
                                        onTap: () {
                                          _showSnackBar(context, '정보 수정');
                                          _nowUserUpdateUserDialog(index);
                                        }
                                    ),
                                    IconSlideAction(
                                        caption: '삭제',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: (){
                                          _showSnackBar(context, '삭제');
                                          GameUser.removeAt(index);
                                          _shopData.game_decrement();
                                        }
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
