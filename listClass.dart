import 'dart:async';

import 'package:demo_app_01_02/database/db_class_helper.dart';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ListClass extends StatelessWidget {
  ListClass({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách phòng thực hành')),
      body: Center(child: ListClassExample()),
    );
  }
}

class ListClassExample extends StatefulWidget {
  const ListClassExample({Key? key});

  @override
  State<ListClassExample> createState() => _ListAccountExampleState();
}

class _ListAccountExampleState extends State<ListClassExample> {
  List<Map<String, dynamic>> _allDataClass = [];
  final MySQLConnectionClass connectionClass = MySQLConnectionClass();
  TextEditingController _nameEquipmentController = TextEditingController();
  void _refreshData() async {
    while (true) {
      final List<Map<String, dynamic>> classList =
          await connectionClass.getAllClass();
      if (mounted) {
        setState(() {
          _allDataClass = classList;
          print(_allDataClass);
        });
      } else {
        // Nếu widget đã bị huỷ bỏ, dừng vòng lặp
        break;
      }

      await Future.delayed(Duration(seconds: 5));
      // Chờ 5 giây trước khi gọi lại hàm
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Timer? timer; // Declare timer as nullable

  @override
  void dispose() {
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
    super.dispose();
  }

  Future<bool> _deleteUser(String idClass) async {
    bool check = await connectionClass.deleteClass(idClass);
    return await check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Danh sách phòng thực hành')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: _allDataClass.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      key: Key(_allDataClass[index]['EquipmentLocationID']
                          .toString()),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _allDataClass[index]['EquipmentLocationName']
                                .toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.blue),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.topSlide,
                                showCloseIcon: true,
                                title: "Cảnh báo",
                                desc: 'Bạn có muốn xóa "' +
                                    _allDataClass[index]
                                            ['EquipmentLocationName']
                                        .toString() +
                                    '" không?',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  await _deleteUser(_allDataClass[index]
                                                  ['EquipmentLocationID']
                                              .toString()) ==
                                          true
                                      ? AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          showCloseIcon: true,
                                          title: "Thành công",
                                          desc: 'Bạn xóa thành công',
                                          btnCancelOnPress: () {},
                                        ).show()
                                      : AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.topSlide,
                                          showCloseIcon: true,
                                          title: "Lỗi",
                                          desc: 'Xóa không thành công',
                                          btnCancelOnPress: () {},
                                        ).show();
                                },
                              ).show();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                _addEquipmentLocationName(context);
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> check(String EquipmentLocationName) async {
    return await connectionClass.isClassExists(EquipmentLocationName);
  }

  void _addEquipmentLocationName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm phòng'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameEquipmentController,
                    decoration: InputDecoration(
                      labelText: 'Tên phòng',
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () async {
                try {
                  if ((!await check(_nameEquipmentController.text) &&
                      (_nameEquipmentController.text != ''))) {
                    await addClass(_nameEquipmentController.text);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Thành công",
                      desc: 'Bạn thêm thành công!',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Thất bại",
                      desc: 'Bạn thêm thất bại!',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  }
                } catch (e) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Thất bại",
                    desc: 'Bạn thêm thất bại!',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                    btnCancelOnPress: () {},
                  ).show();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addClass(String name) async {
    await connectionClass.addClass(name);
  }
}
