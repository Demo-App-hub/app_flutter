import 'dart:async';

import 'package:demo_app_01_02/database/db_borowings_helper.dart';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class ReturnBorrwingScreen extends StatelessWidget {
  ReturnBorrwingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý trả thiết bị')),
      body: Center(child: ReturnBorrwingScreenExample()),
    );
  }
}

class ReturnBorrwingScreenExample extends StatefulWidget {
  const ReturnBorrwingScreenExample({Key? key});

  @override
  State<ReturnBorrwingScreenExample> createState() =>
      _ReturnBorrwingScreenExampleState();
}

class _ReturnBorrwingScreenExampleState
    extends State<ReturnBorrwingScreenExample> {
  List<Map<String, dynamic>> _allDataBorrwings = [];
  final MySQLConnectionBorowings connectionBorowings =
      new MySQLConnectionBorowings();

  void _refreshData() async {
    while (true) {
      final List<Map<String, dynamic>> borrwingList =
          await connectionBorowings.getAllBorrwings();
      if (mounted) {
        setState(() {
          _allDataBorrwings = borrwingList;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: _allDataBorrwings.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    key: Key(
                        _allDataBorrwings[index]['CategoryName'].toString()),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${_allDataBorrwings[index]['EquipmentID'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Tên thiết bị: ${_allDataBorrwings[index]['CategoryName'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Người mượn: ${_allDataBorrwings[index]['fullNameUser'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Ngày mượn: ${_allDataBorrwings[index]['borowingDate'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Phòng: ${_allDataBorrwings[index]['EquipmentLocationName'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Đơn vị: ${_allDataBorrwings[index]['departmentUser'].toString()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Tình trạng: ${_allDataBorrwings[index]['StatusName'].toString()}",
                          style: TextStyle(fontSize: 20),
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
              String idCode = await scanBarcodeNormal();

              //Xử lý khi nút quét QR được bấm
              List<Map<String, dynamic>> infoDeviceCheck = [];
              List<Map<String, dynamic>> infoDevice =
                  await connectionBorowings.isExistsBorrwing(idCode);
              setState(() {
                infoDeviceCheck = infoDevice;
              });
              bool check = infoDeviceCheck.isNotEmpty;
              print("Kiểm traaa : ${check}");
              print(infoDeviceCheck);
              if (check) {
                _editRoom(
                    context,
                    infoDeviceCheck[0]['fullNameUser'].toString(),
                    infoDeviceCheck[0]['CategoryName'].toString(),
                    infoDeviceCheck[0]['EquipmentID'].toString());
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: "Thất bại",
                  desc: 'Không tìm thấy thiết bị!',
                  btnOkOnPress: () {
                    // Navigator.of(context).pop();
                  },
                  // btnCancelOnPress: () {},
                ).show();
              }
            },
            child: Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }

  void _editRoom(BuildContext context, String fullNameUser,
      String nameEquipment, String EquipmentID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trả thiết bị'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text("Tên thiết bị ${nameEquipment}"),
                      Text("Người mượn: ${fullNameUser}"),
                      // Text("data")
                    ],
                  )
                ],
              );
            },
          ),
          actions: <Widget>[
            // TextButton(
            //   child: Text('Hủy'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            TextButton(
              child: Text('Trả'),
              onPressed: () async {
                try {
                  if (await updateStatusBorrwing(EquipmentID)) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Thành công",
                      desc: 'Bạn trả thành công!',
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
                      desc: 'Bạn trả thất bại!',
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

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Thoát",
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      barcodeScanRes = "Lỗi";
    }
    // Hiển thị giá trị mã QR trên màn hình
    return barcodeScanRes;
    // return '420F00000586';
  }

  Future<bool> updateStatusBorrwing(String EquipmentID) async {
    DateTime now = DateTime.now();
    String returnedDate =
        DateFormat('yyyy-MM-dd kk:mm:ss').format(now).toString();
    bool check = await connectionBorowings.UpdateStatusBorrwings(
        EquipmentID, returnedDate);
    return check;
  }
}
