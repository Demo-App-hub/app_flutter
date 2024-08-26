import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csv/csv.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';

class SentFileCsvToEmail extends StatefulWidget {
  @override
  _SentFileCsvToEmailState createState() => _SentFileCsvToEmailState();
}

class _SentFileCsvToEmailState extends State<SentFileCsvToEmail> {
  TextEditingController textController = TextEditingController();
  MySQLConnectionDevice connectionDevice = MySQLConnectionDevice();
  String? email;

  Future<void> kt(String email) async {
    try {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      var file = File('$appDocumentsPath/device_info.csv');
      // var file = File('/storage/emulated/0/Download/device_info1.csv');
      print("ĐƯờng dẫn ${file.path}");
      List list = await connectionDevice.getAllDevicesentEmail();
      List<List<dynamic>> data = [
        ['ID', 'Tên thiết bị', 'Thông tin', 'Tình trạng', 'Phòng'],
      ];
      for (var i = 0; i < list.length; i++) {
        List<dynamic> a = [
          list[i]['EquipmentID'].toString(),
          list[i]['CategoryName'].toString(),
          list[i]['Description'].toString(),
          list[i]['StatusName'].toString(),
          list[i]['EquipmentLocationName'].toString(),
        ];
        data.add(a);
      }

      String csvContent =
          '\uFEFF' + ListToCsvConverter(fieldDelimiter: ',').convert(data);
      // Ghi nội dung vào file
      await File(file.path).writeAsString(csvContent, mode: FileMode.write);

      var fileBorowing = File('$appDocumentsPath/device_borowing.csv');
      // var file = File('/storage/emulated/0/Download/device_info1.csv');
      List listBorowing = await connectionDevice.getDeviceBorowingsSentEmail();
      List<List<dynamic>> dataBorowing = [
        [
          'STT',
          'Tên thiết bị',
          'Người mượn',
          'Ngày mượn',
          'Ngày trả',
          'Số điện thoại',
          'Đơn vị'
        ],
      ];
      //  'borowingID': i[0],
      //     'CategoryName': i[1],
      //     'fullNameUser': i[2],
      //     'borowingDate': i[3],
      //     'returnedDate': i[4],
      //     'phoneNumberUser' : i[5],
      //     'departmentUser' : i[6],
      //   };
      for (var i = 0; i < listBorowing.length; i++) {
        List<dynamic> a = [
          listBorowing[i]['borowingID'].toString(),
          listBorowing[i]['CategoryName'].toString(),
          listBorowing[i]['fullNameUser'].toString(),
          listBorowing[i]['borowingDate'].toString(),
          listBorowing[i]['returnedDate'].toString(),
          listBorowing[i]['phoneNumberUser'].toString(),
          listBorowing[i]['departmentUser'].toString(),
        ];
        dataBorowing.add(a);
      }

      String csvContentBorowing = '\uFEFF' +
          ListToCsvConverter(fieldDelimiter: ',').convert(dataBorowing);
      // Ghi nội dung vào file
      await File(fileBorowing.path)
          .writeAsString(csvContentBorowing, mode: FileMode.write);
      var fileIncident = File('$appDocumentsPath/device_incident.csv');
      // var file = File('/storage/emulated/0/Download/device_info1.csv');
      List listIncident = await connectionDevice.getDeviceIncidentSentEmail();
      List<List<dynamic>> dataIncident = [
        [
          'ID thiết bị',
          'Tên thiết bị',
          'Người thực hiện',
          'Ngày hỏng',
          'Lỗi',
        ],
      ];
      for (var i = 0; i < listIncident.length; i++) {
        List<dynamic> a = [
          listIncident[i]['EquipmentID'].toString(),
          listIncident[i]['CategoryName'].toString(),
          listIncident[i]['FullName'].toString(),
          listIncident[i]['IncidentDate'].toString(),
          listIncident[i]['IncidentDescription'].toString(),
        ];
        dataIncident.add(a);
      }

      String csvContentIncident = '\uFEFF' +
          ListToCsvConverter(fieldDelimiter: ',').convert(dataIncident);
      // Ghi nội dung vào file
      await File(fileIncident.path)
          .writeAsString(csvContentIncident, mode: FileMode.write);
      print('File CSV đã được tạo và dữ liệu được chèn thành công.');
      List<String> listFile = [];
      listFile.add(fileBorowing.path);
      listFile.add(file.path);
      listFile.add(fileIncident.path);
      sentGmailFiles(listFile, email);
    } catch (e) {
      print('Error creating/sending CSV file: $e');
    }
    //Navigator.pop(context);
  }

  Future<void> sentGmailFiles(List<String> csvFilePaths, String email) async {
    try {
      final username = 'demoapp20232024@gmail.com';
      final appPassword = 'mtkx ttgx iymv vyoa';
      final smtpServer = gmail(username, appPassword);
      final message = Message()
        ..from = Address(username)
        ..recipients.add(email)
        ..subject = 'Danh sách thiết bị trong phòng'
        ..text = 'Xuất file từ database.';

      // Thêm từng tệp đính kèm vào email
      for (String csvFilePath in csvFilePaths) {
        message.attachments.add(FileAttachment(File(csvFilePath)));
      }

      await send(message, smtpServer);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Thành công",
        desc: 'Bạn đã gửi email thành công đến email: $email!',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
        btnCancelOnPress: () {},
      ).show();
    } catch (e) {}
  }

  void _getNameDevice() async {
    try {
      List list = await connectionDevice.getAllDevicesentEmail();
      print(list);
    } catch (e) {
      print("Error fetching device data: $e");
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu đã đăng nhập, chuyển hướng đến màn hình chính
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Email', // Update label for clarity
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                print("================================================");
                kt(textController.text.toString());
                print("================================================");
              },
              child: Text('Gửi'),
            ),
            Text(email ?? '', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
