import 'package:flutter/material.dart';

class GameReserveList extends StatefulWidget {
  @override
  _GameReserveListState createState() => _GameReserveListState();
}

class _GameReserveListState extends State<GameReserveList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('명단 관리'),
      ),
      body: Container(
        child: Column(
          children: [
            // // 예약자 현황
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 1,
            //       color: Colors.grey,
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       Text(
            //         '대기 인원 (${_shopData.getReserveNum()})',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //
            //       /// 관리자 직접 예약자 추가
            //       IconButton(
            //           onPressed: () {
            //             // 대기인원 명단 작성
            //             _reserveAddUserDialog();
            //           },
            //           icon: Icon(Icons.add)),
            //       Container(
            //         height: 400,
            //         child: new ListView.builder(
            //           padding: const EdgeInsets.all(8),
            //           itemCount: ReserveUser.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return Slidable(
            //               actionPane: SlidableDrawerActionPane(),
            //               actionExtentRatio: 0.25,
            //               child: new ListTile(
            //                 onTap: () {
            //                   // _showMaterialDialog(
            //                   //     ReserveUser[index], index);
            //                 },
            //                 leading: Icon(Icons.person),
            //                 title: Text(ReserveUser[index].toString()),
            //               ),
            //
            //               /// 왼쪽 슬라이더블
            //               // actions: <Widget>[
            //               //   IconSlideAction(
            //               //     caption: 'Archive',
            //               //     color: Colors.blue,
            //               //     icon: Icons.archive,
            //               //     onTap: () => _showSnackBar(context, 'Archive'),
            //               //   ),
            //               //   IconSlideAction(
            //               //     caption: 'Share',
            //               //     color: Colors.indigo,
            //               //     icon: Icons.share,
            //               //     onTap: () => _showSnackBar(context, 'Share'),
            //               //   ),
            //               // ],
            //               /// 오른쪽 슬라이더블
            //               secondaryActions: <Widget>[
            //                 IconSlideAction(
            //                     caption: '상태 변경',
            //                     color: Colors.black45,
            //                     icon: Icons.move_to_inbox,
            //                     onTap: () {
            //                       _showSnackBar(context, '현재 인원으로');
            //
            //                       setState(() {
            //                         // GameUser에 status 추가
            //                         firestoreInstance
            //                             .collection('Shop')
            //                         // 가게이름
            //                             .doc('jackpotrounge')
            //                         // 게임별 인덱스 설정
            //                             .collection('Games')
            //                             .doc('Game1')
            //                             .collection('GameList')
            //                             .doc('${ReserveUser[index]}')
            //                             .set({
            //                           "name": "$ReserveUser[index]"
            //                         }).then((_) => print('대기 인원 삭제'));
            //                         GameUser.add(ReserveUser[index]);
            //
            //                         // ReserveUser에서 status 삭제
            //                         firestoreInstance
            //                             .collection('Shop')
            //                         // 가게이름
            //                             .doc('jackpotrounge')
            //                         // 게임별 인덱스 설정
            //                             .collection('Games')
            //                             .doc('Game1')
            //                             .collection('ReserveList')
            //                             .doc('${ReserveUser[index]}')
            //                             .delete()
            //                             .then((_) => print('대기 인원 삭제'));
            //                         ReserveUser.removeAt(index);
            //                         _shopData.reserve_decrement();
            //                         _shopData.game_increment();
            //                       });
            //                     }),
            //                 IconSlideAction(
            //                     caption: '정보수정',
            //                     color: Colors.blue,
            //                     icon: Icons.update,
            //                     onTap: () {
            //                       _showSnackBar(context, '정보 수정');
            //                       _reserveUpdateUserDialog(index);
            //                     }),
            //                 IconSlideAction(
            //                     caption: '삭제',
            //                     color: Colors.red,
            //                     icon: Icons.delete,
            //                     onTap: () {
            //                       _showSnackBar(context, '삭제');
            //                       firestoreInstance
            //                           .collection('Shop')
            //                       // 가게이름
            //                           .doc('jackpotrounge')
            //                       // 게임별 인덱스 설정
            //                           .collection('Games')
            //                           .doc('Game1')
            //                           .collection('ReserveList')
            //                           .doc('${ReserveUser[index]}')
            //                           .delete()
            //                           .then((_) => print('대기 인원 삭제'));
            //                       ReserveUser.removeAt(index);
            //                       _shopData.reserve_decrement();
            //                     }),
            //               ],
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // // 게임 대기 인원 (매장 내 있는 인원)
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 1,
            //       color: Colors.grey,
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       Text(
            //         '현재인원 (${_shopData.getGameNum()})',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       // 사용자 현재인원 직접 추가
            //       IconButton(
            //           onPressed: () {
            //             _nowUserAddDialog();
            //           },
            //           icon: Icon(Icons.add)),
            //       Container(
            //         height: 400,
            //         child: new ListView.builder(
            //           padding: const EdgeInsets.all(8),
            //           itemCount: GameUser.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return Slidable(
            //               actionPane: SlidableDrawerActionPane(),
            //               actionExtentRatio: 0.25,
            //               child: new ListTile(
            //                 leading: Icon(Icons.person),
            //                 title: Text(GameUser[index].toString()),
            //                 // subtitle:
            //                 //     Text(GameUser[index].toString()),
            //                 // trailing: Text(
            //                 //     GameUser[index].toString()),
            //               ),
            //
            //               /// 오른쪽 슬라이더블
            //               secondaryActions: <Widget>[
            //                 // IconSlideAction(
            //                 //     caption: '상태 변경',
            //                 //     color: Colors.black45,
            //                 //     icon: Icons.move_to_inbox,
            //                 //     onTap: () {
            //                 //       _showSnackBar(context, '현재 인원으로');
            //                 //
            //                 //       setState(() {
            //                 //         // GameUser에 status 추가
            //                 //         GameUser.add(ReserveUser[index]);
            //                 //         // ReserveUser에서 status 삭제
            //                 //         ReserveUser.removeAt(index);
            //                 //         _shopData.reserve_decrement();
            //                 //         _shopData.now_increment();
            //                 //       });
            //                 //     }
            //                 // ),
            //                 IconSlideAction(
            //                     caption: '정보수정',
            //                     color: Colors.blue,
            //                     icon: Icons.update,
            //                     onTap: () {
            //                       _showSnackBar(context, '정보 수정');
            //                       _nowUserUpdateUserDialog(index);
            //                     }),
            //                 IconSlideAction(
            //                     caption: '삭제',
            //                     color: Colors.red,
            //                     icon: Icons.delete,
            //                     onTap: () {
            //                       _showSnackBar(context, '삭제');
            //                       firestoreInstance
            //                           .collection('Shop')
            //                       // 가게이름
            //                           .doc('jackpotrounge')
            //                       // 게임별 인덱스 설정
            //                           .collection('Games')
            //                           .doc('Game1')
            //                           .collection('GameList')
            //                           .doc('${GameUser[index]}')
            //                           .delete()
            //                           .then((_) => print('게임 인원 삭제'));
            //                       GameUser.removeAt(index);
            //                       _shopData.game_decrement();
            //                     }),
            //               ],
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
