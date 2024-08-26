// ignore_for_file: file_names
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/database/db_class_helper.dart';
import 'package:flutter/material.dart';

class AddClass extends StatelessWidget {
  const AddClass({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Thêm phòng'),
        ),
        body: const Center(child: AddClassExample()),
      ),
    );
  }
}

class AddClassExample extends StatefulWidget {
  const AddClassExample({super.key});

  @override
  State<AddClassExample> createState() => _AddClassExampleState();
}

final TextEditingController _nameClassController = TextEditingController();

class _AddClassExampleState extends State<AddClassExample> {
  final MySQLConnectionClass connectionClass = MySQLConnectionClass();
  // DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10)),
        TextField(
          controller: _nameClassController,
          decoration: const InputDecoration(
            labelText: 'Tên phòng',
          ),
        ),
        const SizedBox(height: 24.0),
        const Padding(padding: EdgeInsets.all(10)),
        Row(children: [
          Container(
            width: 100,
            height: 50,
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                connectionClass
                    .isClassExists(_nameClassController.text.toString());
                // _addClass();
                if (_nameClassController.text.toString() == "") {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Lỗi",
                    desc: 'Bạn chưa thêm thành công!',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                    btnCancelOnPress: () {},
                  ).show();
                } else {
                  _addClass(_nameClassController.text.toString());

                  setTex();
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
                    // btnCancelOnPress: () {},
                  ).show();
                }
              },
              child: const Text("Thêm"),
            ),
          ),
        ]),
      ],
    )));
  }

  void setTex() {
    _nameClassController.text = "";
  }

  // Future<bool> _kt(String nameClass) async {
  //   return await connectionClass.isClassExists(nameClass);
  // }

  Future<void> _addClass(String nameClass) async {
    connectionClass.addClass(nameClass);
    // await databaseHelper.addClass(_nameClassController.text.toString());
  }

  // Future<void> _insertClass() async {
  //   await SQLHelper.insertClass(_nameClassController.text.toString());
  // }
}
