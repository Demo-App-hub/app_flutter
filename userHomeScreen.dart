// ignore: file_names
// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/addDevice.dart';
import 'package:demo_app_01_02/categoryDataScreen.dart';
import 'package:demo_app_01_02/database/db_class_helper.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:demo_app_01_02/database/db_notifications_helper.dart';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:demo_app_01_02/infoDeviceUser.dart';
import 'package:demo_app_01_02/listDeviceAdmin.dart';
import 'package:demo_app_01_02/listDeviceClassAdmin.dart';
import 'package:demo_app_01_02/listDeviceClassUser.dart';
import 'package:demo_app_01_02/loginScreen.dart';
import 'package:demo_app_01_02/notificationsScreen.dart';
import 'package:demo_app_01_02/src/authManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class UserHomeScreen extends StatefulWidget {
  final AuthManager authManager;
  final String username;
  // AdminHomeScreen(this.authManager, {Key? key, required this.username});
  UserHomeScreen(this.authManager, {required this.username});

  // AdminHomeScreen(this.authManager, {super.key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<String>? infoUser = [];
  final MySQLConnectionUser connectionUser = new MySQLConnectionUser();
  late int notificationCount = 0;
  List<Map<String, dynamic>> _allDataClass = [];
  List<Map<String, dynamic>> _allDataStatus = [];
  List<Map<String, dynamic>> _allDataStatusOne = [];
  final MySQLConnectionDevice _connectionDevice = new MySQLConnectionDevice();
  final MySQLConnectionClass connectionClass = MySQLConnectionClass();
  final MySQLConnectionNotification connectionNotification =
      new MySQLConnectionNotification();
  void _refreshData() async {
    while (true) {
      final List<String> listUser =
          await connectionUser.getInfo(widget.username);
      final List<Map<String, dynamic>> classList =
          await connectionClass.getAllClass();
      List<Map<String, dynamic>> listStatus = [];
      List<Map<String, dynamic>> listStatusOne = [];
      for (int i = 0; i < classList.length; i++) {
        listStatus.addAll(await _connectionDevice
            .countEquipmentStatus(classList[i]['EquipmentLocationID']));
        listStatusOne.addAll(await _connectionDevice
            .countEquipmentStatusOne(classList[i]['EquipmentLocationID']));
      }
      final List<Map<String, dynamic>> coutNotification =
          await connectionNotification.countAllNotifications();
      if (mounted) {
        setState(() {
          notificationCount = coutNotification[0]['total'];
          infoUser = listUser;
          _allDataClass = classList;
          _allDataStatus = listStatus;
          _allDataStatusOne = listStatusOne;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('App demo 2024'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                tooltip: 'Hiển thị Snackbar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage(
                              UserID: infoUser![0],
                              id: infoUser![0],
                            )),
                  );
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Welcome, ${infoUser?.isNotEmpty ?? false ? infoUser![3] : "Đang tải..."}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8), // Khoảng cách giữa hai dòng
                    Text(
                      infoUser?.isNotEmpty ?? false
                          ? infoUser![1]
                          : "Đang tải...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
            ListTile(
              title: const Text('Danh sách thiết bị'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListDeviceAdmin()),
                );
              },
            ),
            // ListTile(
            //   title: const Text('Danh sách phòng thực hành'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ListClass()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: const Text('Báo cáo'),
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => SentFileCsvToEmail()),
            //     // );
            //   },
            // ),
            ListTile(
              title: const Text('Đăng xuất'),
              onTap: () {
                widget.authManager.removeCredentials();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: (_allDataClass.isEmpty)
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
          : SingleChildScrollView(
              child: GridView.count(
                childAspectRatio: 0.68,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < _allDataClass.length; i++)
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: (KienTra(_allDataStatusOne[i]['total'],
                                              _allDataStatus[i]['total'])) >=
                                          50
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListDeviceClassUser(
                                          EquipmentLocationID: _allDataClass[i]
                                              ['EquipmentLocationID'],
                                          EquipmentLocationName:
                                              _allDataClass[i]
                                                      ['EquipmentLocationName']
                                                  .toString())));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Icon(Icons
                                  .class_), // Thay 'Icons.class_' bằng biểu tượng mong muốn
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.center,
                            child: Text(
                              '${_allDataClass[i]['EquipmentLocationName']}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Hoạt động ${_allDataStatusOne[i]['total']}/${_allDataStatus[i]['total']}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("------"),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String idCode = await scanBarcodeNormal();

          //Xử lý khi nút quét QR được bấm
          final MySQLConnectionDevice connectionDevice =
              MySQLConnectionDevice();
          Future<bool> check =
              connectionDevice.isEDeviceExists(idCode.toString());
          if (await check) {
            final List<Map<String, dynamic>> infoDevice =
                await connectionDevice.getInfoDevice(idCode);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EquipmentInfoScreenUser(
                  EquipmentID: infoDevice[0]['EquipmentID']
                      .toString(), // Truyền giá trị idDevice
                  CategoryName: infoDevice[0]['CategoryName'].toString(),
                  Description: infoDevice[0]['Description'].toString(),
                  StatusName: infoDevice[0]['StatusName'].toString(),
                  EquipmentLocationName:
                      infoDevice[0]['EquipmentLocationName'].toString(),
                  UserID: infoUser?.isNotEmpty ?? false ? infoUser![0] : "",
                ),
              ),
            );
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
          // Đoạn mã xử lý quét QR code có thể được thêm ở đây
        },
        child: Icon(Icons.qr_code),
      ),
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

  // Future<int> countEquipmentStatusOne(int EquipmentLocationID) async {
  //   return await _connectionDevice.countEquipmentStatusOne(EquipmentLocationID);
  // }

  // ignore: non_constant_identifier_names
  // int countEquipmentStatusOne(int EquipmentLocationID) async {
  //   try {
  //     int a = await _connectionDevice.countEquipmentStatus(EquipmentLocationID);
  //     return a;
  //   } catch (e) {
  //     print("Error: $e");
  //     return -1; // Hoặc giá trị mặc định khác tùy thuộc vào trường hợp của bạn
  //   }
  // }
  double KienTra(int a, int b) {
    return ((a / b) * 100).toDouble();
  }
}
