import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/database/db_category_helper.dart';
import 'package:demo_app_01_02/database/db_class_helper.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:flutter/material.dart';

Map<String, String> categoryName = <String, String>{
  'Tất cả': 'Tất cả',
};

class ListDeviceClassUser extends StatefulWidget {
  final int EquipmentLocationID;
  final String EquipmentLocationName;

  ListDeviceClassUser({
    required this.EquipmentLocationID,
    required this.EquipmentLocationName,
  });

  @override
  _ListDeviceClassUserState createState() => _ListDeviceClassUserState();
}

class _ListDeviceClassUserState extends State<ListDeviceClassUser> {
  final MySQLConnectionClass _connectionClass = new MySQLConnectionClass();
  final MySQLConnectionDevice connectionDevice = MySQLConnectionDevice();
  final MySQLConnectionCategory _connectionCategory =
      new MySQLConnectionCategory();
  String? selectedNameDevice, valueStatus;
  String? nameClass;
  List<Map<String, dynamic>> _allData = [];
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    while (true) {
      final List<Map<String, dynamic>> deviceList =
          await connectionDevice.getAllDeviceClass(widget.EquipmentLocationID);
      final List<Map<String, dynamic>> _allDataCategory =
          await _connectionCategory.getAllCategory();

      // Cập nhật danh sách các tên danh mục
      Map<String, String> updatedCategoryName = {};
      for (int i = 0; i < _allDataCategory.length; i++) {
        updatedCategoryName['${_allDataCategory[i]['CategoryName']}'] =
            _allDataCategory[i]['CategoryName'].toString();
      }

      // Kiểm tra xem đối tượng State vẫn còn trong cây widget trước khi gọi setState()
      if (mounted) {
        setState(() {
          categoryName = updatedCategoryName;
          _allData = deviceList;
        });
      } else {
        break;
      }

      // Đợi một khoảng thời gian trước khi gọi lại hàm _refreshData()
      await Future.delayed(Duration(seconds: 5));
    }
  }

  Timer? timer; // Declare timer as nullable

  @override
  void dispose() {
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
    super.dispose();
  }

  // void _getNameDevice(String nameDevice) async {
  //   final List<Map<String, dynamic>> deviceList =
  //       await connectionDevice.getNameDevice(nameDevice);
  //   setState(() {
  //     _allData = deviceList;
  //   });
  // }

  // void _getNameDevice(String nameDevice) async {
  //   final data = await SQLHelper.getNameDevice(nameDevice);
  //   setState(() {
  //     _allData = data;
  //   });
  // }
  // Future<void> iniState() async {
  //   super.initState();
  //   _refreshData();
  // }

  @override
  Widget build(BuildContext context) {
    return _allData.isEmpty
        ? Scaffold(
            appBar: AppBar(
              title: Text('Danh sách thiết bị'),
            ),
            body: Center(
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
            )),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Danh sách thiết bị'),
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  // new Container(
                  //   child: new Flexible(
                  //     child: new DropdownButton<String>(
                  //       items: categoryName.keys
                  //           .map<DropdownMenuItem<String>>((String item) {
                  //         return DropdownMenuItem<String>(
                  //           value: item,
                  //           child: Text(item),
                  //         );
                  //       }).toList(),
                  //       value: selectedNameDevice,
                  //       onChanged: (_value) {
                  //         // This is called when the user selects an item.
                  //         setState(() {
                  //           secondvaluechanged(_value);
                  //           selectedNameDevice = _value!;
                  //           if (selectedNameDevice == "Tất cả") {
                  //             _refreshData();
                  //           } else {
                  //             // _getNameDevice(selectedNameDevice.toString());
                  //           }
                  //         });
                  //       },
                  //       hint: Text("Tên thiết bị"),
                  //       selectedItemBuilder: (BuildContext context) {
                  //         return categoryName.values.map<Widget>((String item) {
                  //           // This is the widget that will be shown when you select an item.
                  //           // Here custom text style, alignment and layout size can be applied
                  //           // to selected item string.
                  //           return Container(
                  //             alignment: Alignment.centerLeft,
                  //             constraints: const BoxConstraints(minWidth: 50),
                  //             child: Text(
                  //               item,
                  //               style: const TextStyle(
                  //                   color: Colors.blue,
                  //                   fontWeight: FontWeight.w600),
                  //             ),
                  //           );
                  //         }).toList();
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(
                      // height: MediaQuery.of(context).size.height * 7 / 9,

                      child: Expanded(
                    child: ListView.builder(
                        itemCount: _allData.length,
                        itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.all(15),
                            child: Container(
                                child: Column(children: <Widget>[
                              ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100, // Đặt độ rộng của Text 'Số'
                                        height:
                                            100, // Đặt chiều cao của Text 'Số'
                                        alignment: Alignment
                                            .center, // Căn giữa nội dung trong container
                                        child: Text(
                                          _allData[index]['NumberEquipment']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize:
                                                35, // Tuỳ chỉnh kích thước phông chữ
                                            fontWeight: FontWeight
                                                .bold, // Tuỳ chỉnh độ đậm
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _allData[index]['CategoryName']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              "ID: " +
                                                  _allData[index]['EquipmentID']
                                                      .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              "Tình trạng: " +
                                                  _allData[index]['StatusName']
                                                      .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [],
                                ),
                                // onTap: () {
                                //   Navigator.of(context).push(MaterialPageRoute(

                                //   ));
                                // },
                              ),
                            ])))),
                  )),
                ],
              ),
            ));
  }

  void secondvaluechanged(_value) {
    setState(() {
      valueStatus = _value;
    });
  }

  void _deleteData(String idDevice) async {
    await connectionDevice.deleteDevice(idDevice);
    _refreshData();
  }
}
