import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/database/db_category_helper.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// List<String> nameDevice = ["Máy tính", "Máy in", "Điều hòa", "Máy chiếu"];

TextEditingController _idDeviceController = TextEditingController();
TextEditingController _infoDeviceController = TextEditingController();
int? _selectedCategoryID;
int? _selectedStatusID;
String? valueStatus, _nameDevice, _statusDevice, valueName;

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  List<Map<String, dynamic>> categoryName = [];
  List<Map<String, dynamic>> statusEquipment = [];
  // Biến để lưu trữ giá trị hiện tại được chọn
  final MySQLConnectionDevice connectionDevice = MySQLConnectionDevice();
  final MySQLConnectionCategory connectionCategory =
      new MySQLConnectionCategory();

  int? _selectedCategoryID;
  int? _selectedStatusID;
  void _refreshData() async {
    List<Map<String, dynamic>> _allStatusCategory =
        await connectionDevice.getAllStatusDevice();
    List<Map<String, dynamic>> _allCategory =
        await connectionCategory.getAllCategory();
    setState(() {
      statusEquipment = _allStatusCategory;
      categoryName = _allCategory;
    });
  }

  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thiết bị')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _idDeviceController,
                    decoration: InputDecoration(labelText: 'Mã thiết bị'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: scanBarcodeNormal,
                ),
              ],
            ),
            DropdownButton<int>(
              value: _selectedCategoryID,
              hint: Text('Chọn loại thiết bị'),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategoryID = newValue;
                  print('Loại thiết bị ${_selectedCategoryID}');
                });
              },
              items: categoryName.map((Map<String, dynamic> category) {
                return DropdownMenuItem<int>(
                  value: category['CategoryID'],
                  child: Text(category['CategoryName'].toString()),
                );
              }).toList(),
            ),
            TextField(
              controller: _infoDeviceController,
              decoration: InputDecoration(labelText: 'Thông tin thiết bị'),
            ),
            DropdownButton<int>(
              value: _selectedStatusID,
              hint: Text('Chọn tình trạng thiết bị'),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatusID = newValue;
                  print('Loại thiết bị ${_selectedStatusID}');
                });
              },
              items: statusEquipment.map((Map<String, dynamic> status) {
                return DropdownMenuItem<int>(
                  value: status['StatusID'],
                  child: Text(status['StatusName'].toString()),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addDevice() == true
                    ? AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: "Thành công",
                        desc: 'Bạn thêm thành công!',
                        btnOkOnPress: () {
                          set();
                          Navigator.of(context).pop();
                        },
                        btnCancelOnPress: () {},
                      ).show()
                    : AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: "Thất bại",
                        desc: 'Bạn thêm thất bại!',
                        btnOkOnPress: () {
                          // Navigator.of(context).pop();
                        },
                        btnCancelOnPress: () {},
                      ).show();
                ;
              },
              child: Text("Thêm"),
            ),
          ],
        ),
      ),
    );
  }

  void scanBarcodeNormal() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Thoát", true, ScanMode.QR);
    if (!mounted) return;
    setState(() {
      if (barcodeScanRes.toString() == '-1') {
        _idDeviceController.text = '';
      } else {
        _idDeviceController.text = barcodeScanRes;
      }
    });
  }

  Future<bool> _addDevice() async {
    if (_idDeviceController.text == '' ||
        _selectedCategoryID == null ||
        _infoDeviceController.text == '' ||
        _selectedStatusID == null) {
      return false;
    } else {
      return await connectionDevice.addDevice(
        _idDeviceController.text.toString(),
        _selectedCategoryID!,
        _infoDeviceController.text.toString(),
        _selectedStatusID!,
      );
    }
  }

  Future<void> _addDevice1() async {
    if (_idDeviceController.text.isEmpty ||
        _selectedCategoryID == null ||
        _infoDeviceController.text.isEmpty ||
        _selectedStatusID == null) {
      // Show error dialog
    } else {
      // Proceed to add device to database
    }
  }

  void set() {
    _idDeviceController.text = "";
    _infoDeviceController.text = "";
  }
}
