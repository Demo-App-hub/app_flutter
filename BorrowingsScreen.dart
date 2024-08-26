import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/database/db_borowings_helper.dart';
import 'package:demo_app_01_02/database/db_category_helper.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

// List<String> nameDevice = ["Máy tính", "Máy in", "Điều hòa", "Máy chiếu"];

TextEditingController _fullNameController = TextEditingController();
TextEditingController _phoneNumberController = TextEditingController();
TextEditingController _departmentController = TextEditingController();

class BorrowingsScreen extends StatefulWidget {
  @override
  _BorrowingsScreenState createState() => _BorrowingsScreenState();
}

class _BorrowingsScreenState extends State<BorrowingsScreen> {
  List<Map<String, dynamic>> categoryName = [];
  List<Map<String, dynamic>> statusEquipment = [];
  // Biến để lưu trữ giá trị hiện tại được chọn
  final MySQLConnectionBorowings connectionBorowings =
      new MySQLConnectionBorowings();
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

  List<TextField> textFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý mượn thiết bị')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: textFields,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: _scanAndAddTextField,
                ),
              ],
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Thông tin người mượn'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'SĐT người mượn'),
            ),
            TextField(
              controller: _departmentController,
              decoration: InputDecoration(labelText: 'Đơn vị người mượn'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                _addBorowing();
                ;
              },
              child: Text("Mượn"),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Thoát", true, ScanMode.QR);
    return barcodeScanRes;
  }

  List<String> test() {
    List<String> textFieldValues = getTextFieldValues();
    return textFieldValues;
  }

  List<String> getTextFieldValues() {
    List<String> values = [];
    for (TextField textField in textFields) {
      values.add(textField.controller!.text);
    }
    return values;
  }

  Future<void> _scanAndAddTextField() async {
    // Quét mã vạch để lấy mã thiết bị
    String barcode = await scanBarcodeNormal();
    Future<bool> checkBarCode =
        connectionDevice.isEDeviceExists(barcode.toString());
    bool isBarcodeExist = textFields.any(
        (textField) => textField.controller!.text.trim() == barcode.trim());
    // List<Map<String, dynamic>> listBorrwing =
    //     await connectionBorowings.queryStatus(barcode);
    // int checkStatus = int.parse(listBorrwing[0]['StatusBorowing']);
    if (await checkBarCode && !isBarcodeExist) {
      TextEditingController controller = TextEditingController(text: barcode);

      // Thêm một TextField mới với mã thiết bị được quét vào danh sách
      _addTextField(controller);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Lỗi",
        desc: 'Thiết bị đã nhập hoặc thiết bị chưa nhập!',
        btnOkOnPress: () {
          // Navigator.of(context).pop();
        },
        btnCancelOnPress: () {},
      ).show();
    }
    // Kiểm tra xem mã vạch đã tồn tại trong danh sách TextField hay chưa
  }

  void _addTextField(TextEditingController textEditing) {
    setState(() {
      textFields.add(
        TextField(
          controller: textEditing,
          decoration: InputDecoration(labelText: 'Mã thiết bị'),
        ),
      );
    });
  }

  void _addBorowing() async {
    if (_fullNameController.text == '' ||
        _phoneNumberController.text == '' ||
        _departmentController.text == '') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Lỗi",
        desc: 'Vui lòng nhập đúng thông tin!',
        btnOkOnPress: () {
          // Navigator.of(context).pop();
        },
        btnCancelOnPress: () {},
      ).show();
    } else {
      List<String> listEquipmentID = test();
      DateTime now = DateTime.now();
      String borowingDate =
          DateFormat('yyyy-MM-dd kk:mm:ss').format(now).toString();
      listEquipmentID.forEach((value) async {
        await connectionBorowings.addBorowings(
            value,
            _fullNameController.text,
            borowingDate,
            '',
            _phoneNumberController.text,
            _departmentController.text);
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Thành công",
        desc: 'Tạo lệnh cho mượn thành công!',
        btnOkOnPress: () {
          // Navigator.of(context).pop();
        },
        btnCancelOnPress: () {},
      ).show();
      set();
    }
  }

  void set() {
    _fullNameController.text = '';
    _departmentController.text = '';
    _phoneNumberController.text = '';
  }

  // Future<void> _addDevice1() async {
  //   if (_idDeviceController.text.isEmpty ||
  //       _selectedCategoryID == null ||
  //       _infoDeviceController.text.isEmpty ||
  //       _selectedStatusID == null) {
  //     // Show error dialog
  //   } else {
  //     // Proceed to add device to database
  //   }
  // }
}
