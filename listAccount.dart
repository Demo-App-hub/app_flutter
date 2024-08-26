import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ListAccount extends StatelessWidget {
  ListAccount({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách tài khoản')),
      body: Center(child: ListAccountExample()),
    );
  }
}

class ListAccountExample extends StatefulWidget {
  const ListAccountExample({Key? key});

  @override
  State<ListAccountExample> createState() => _ListAccountExampleState();
}

class _ListAccountExampleState extends State<ListAccountExample> {
  List<Map<String, dynamic>> _allDataUser = [];
  final MySQLConnectionUser connectionUser = MySQLConnectionUser();

  void _refreshData() async {
    while (true) {
      final List<Map<String, dynamic>> userList =
          await connectionUser.getAllUser();
      if (mounted) {
        setState(() {
          _allDataUser = userList;
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

  void _deleteUser(String email) async {
    connectionUser.deleteUser(email);
    _refreshData();
  }

  void _updateUser(String email) {
    // Thực hiện cập nhật người dùng
    // ...
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: _allDataUser.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    key: Key(_allDataUser[index]['Email'].toString()),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _allDataUser[index]['FullName'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          _allDataUser[index]['Email'].toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          "Quyền: " + (_allDataUser[index]['Role']).toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    trailing: _allDataUser[index]['Role'] == "Admin"
                        ? Text("")
                        : Row(
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
                                        _allDataUser[index]['FullName']
                                            .toString() +
                                        '" không?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      _deleteUser(_allDataUser[index]['Email']
                                          .toString());
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
        ],
      ),
    );
  }
}
