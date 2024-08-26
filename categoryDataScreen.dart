import 'dart:async';

import 'package:demo_app_01_02/database/db_category_helper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CategoryDataScreen extends StatelessWidget {
  CategoryDataScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách loại thiết bị')),
      body: Center(child: CategoryDataScreenExample()),
    );
  }
}

class CategoryDataScreenExample extends StatefulWidget {
  const CategoryDataScreenExample({Key? key});

  @override
  State<CategoryDataScreenExample> createState() => _ListAccountExampleState();
}

class _ListAccountExampleState extends State<CategoryDataScreenExample> {
  late var timer;
  List<Map<String, dynamic>> AllListCategory = [];
  final TextEditingController _nameCategoryController = TextEditingController();
  final MySQLConnectionCategory connectionCategory = MySQLConnectionCategory();
  void _refreshData() async {
    // while (true) {
    //   final List<Map<String, dynamic>> ListCategory =
    //       await connectionCategory.getAllCategory();

    //   setState(() {
    //     AllListCategory = ListCategory;
    //   });
    //   await Future.delayed(Duration(seconds: 20));
    //   // Chờ 5 giây trước khi gọi lại hàm
    // }
    final List<Map<String, dynamic>> ListCategory =
        await connectionCategory.getAllCategory();

    setState(() {
      AllListCategory = ListCategory;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    if (mounted) {
      timer = new Timer.periodic(
          Duration(seconds: 10),
          (Timer t) => setState(() {
                _refreshData();
              }));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // void _deleteUser(String email) async {
  //   connectionUser.deleteUser(email);
  //   _refreshData();
  // }

  void _updateUser(String email) {
    // Thực hiện cập nhật người dùng
    // ...
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return AllListCategory.isEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Đang tải"),
              SizedBox(height: 16),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                transform: Matrix4.rotationZ(0.25),
                child: CircularProgressIndicator(),
              ),
            ],
          ))
        : SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: AllListCategory.length,
                      itemBuilder: (context, index) => Card(
                        margin: EdgeInsets.all(15),
                        child: ListTile(
                          key: Key(AllListCategory[index]['CategoryName']
                              .toString()),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AllListCategory[index]['CategoryName'].toString()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                'ID: ${AllListCategory[index]['CategoryID'].toString()}',
                                style: TextStyle(fontSize: 17),
                              ),
                              // Text(
                              //   "Quyền: " +
                              //       (_allDataUser[index]['status']).toString(),
                              //   style: TextStyle(fontSize: 20),
                              // ),
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
                                        AllListCategory[index]['CategoryName']
                                            .toString() +
                                        '" không?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      deleteCategory(AllListCategory[index]
                                                  ['CategoryID']) ==
                                              true
                                          ? AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              headerAnimationLoop: false,
                                              animType: AnimType.bottomSlide,
                                              title: 'Thất bại',
                                              desc: 'Bạn xóa không thành công',
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              showCloseIcon: true,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {},
                                            ).show()
                                          : AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              headerAnimationLoop: false,
                                              animType: AnimType.bottomSlide,
                                              title: 'Thành công',
                                              desc: 'Bạn đã xóa thành công',
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              showCloseIcon: true,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {},
                                            ).show();
                                    },
                                  ).show();
                                },
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.update),
                              //   onPressed: () {
                              //     _updateUser(_allDataUser[index]['email'].toString());
                              //   },
                              // ),
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
          );
  }

  Future<bool> deleteCategory(int categoryID) async {
    bool check = await connectionCategory.deleteCategory(categoryID);
    _refreshData();
    return check;
  }

  Future<bool> check(String CategoryName) async {
    return await connectionCategory.isCategoryExists(CategoryName);
  }

  void _addEquipmentLocationName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm loại thiết bị'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Tên loại thiết b',
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
                  if ((!await check(_nameCategoryController.text) &&
                      (_nameCategoryController.text != ''))) {
                    await addCategory(_nameCategoryController.text);
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

  Future<void> addCategory(String name) async {
    await connectionCategory.addCategory(name);
  }
}
