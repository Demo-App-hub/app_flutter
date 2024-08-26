import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:demo_app_01_02/database/db_class_helper.dart';
import 'package:demo_app_01_02/database/db_device_helper.dart';
import 'package:demo_app_01_02/database/db_notifications_helper.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EquipmentInfoScreenUser extends StatefulWidget {
  final String EquipmentID;
  final String CategoryName;
  final String Description;
  final String StatusName;
  final String EquipmentLocationName;
  final String UserID;

  EquipmentInfoScreenUser({
    required this.EquipmentID,
    required this.CategoryName,
    required this.Description,
    required this.StatusName,
    required this.EquipmentLocationName,
    required this.UserID,
  });

  @override
  _EquipmentInfoScreenUserState createState() =>
      _EquipmentInfoScreenUserState();
}

class _EquipmentInfoScreenUserState extends State<EquipmentInfoScreenUser> {
  List<Map<String, dynamic>> equipmentLocationList = [];
  List<Map<String, dynamic>> statusEquipmentList = [];
  // Biến để lưu trữ giá trị hiện tại được chọn
  final TextEditingController _inforStatusEquipmentController =
      TextEditingController();
  int? _selectedStatusID;
  int? _selectedRoomId;
  List<Map<String, dynamic>> statusEquipment = [];
  List<Map<String, dynamic>> infoDevice = [];
  List<Map<String, dynamic>> listClass = [];
  final MySQLConnectionNotification connectionNotification =
      new MySQLConnectionNotification();
  final MySQLConnectionDevice connectionDevice = new MySQLConnectionDevice();
  MySQLConnectionClass connectionClass = new MySQLConnectionClass();
  Future<void> getStatusEquipment() async {
    List<Map<String, dynamic>> _allStatusCategory =
        await connectionDevice.getAllStatusDevice();
    setState(() {
      statusEquipment = _allStatusCategory;
    });
  }

  void getListClass() async {
    final List<Map<String, dynamic>> classList =
        await connectionClass.getAllClass();
    setState(() {
      listClass = classList;
    });
  }

  void selecttDevice() async {
    final List<Map<String, dynamic>> userList =
        await connectionDevice.getInfoDevice(widget.EquipmentID);
    setState(() {
      infoDevice = userList;
    });
  }

  void set() {
    selecttDevice();
    getListClass();
    getStatusEquipment();
  }

  @override
  void initState() {
    super.initState();
    set();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            // 'EquipmentID': i[0],
            // 'CategoryName': i[1],
            // 'Description': i[2],
            // 'StatusName': i[3],
            // 'EquipmentLocationName': i[4],
            '${infoDevice.isNotEmpty ? infoDevice[0]['CategoryName'].toString() : 'Đang tải...'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(
                'ID thiết bị',
                infoDevice.isNotEmpty
                    ? infoDevice[0]['EquipmentID'].toString()
                    : 'Đang tải...'),
            _buildInfoItem(
                'Thông tin thiết bị',
                infoDevice.isNotEmpty
                    ? infoDevice[0]['Description'].toString()
                    : 'Đang tải...'),
            _buildInfoItem(
              'Số máy',
              infoDevice.isNotEmpty
                  ? (infoDevice[0]['NumberEquipment'].toString() == ''
                      ? 'Chưa có'
                      : infoDevice[0]['NumberEquipment'].toString())
                  : 'Đang tải...',
            ),
            _buildInfoItem(
              'Phòng',
              infoDevice.isNotEmpty
                  ? infoDevice[0]['EquipmentLocationName'].toString()
                  : 'Đang tải...',
              // onPressed: () {
              //   _editStatus(context);
              // },
            ),
            _buildInfoItem(
              'Trạng thái hoạt động',
              infoDevice.isNotEmpty
                  ? infoDevice[0]['StatusName'].toString()
                  : 'Đang tải...',
              onPressed: () {
                _editStatus(context);
              },
            ),

            // Row(
            //   children: [
            //     ElevatedButton(onPressed: (){
            //      _editStatus(context);
            //     },
            //     child: Text(widget.deviceName))
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onPressed != null)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onPressed,
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  void _editStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Chỉnh sửa trạng thái hoạt động của ${widget.CategoryName}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  TextFormField(
                    controller: _inforStatusEquipmentController,
                    decoration: InputDecoration(
                      labelText: 'Lỗi hỏng',
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
              onPressed: () {
                DateTime now = DateTime.now();
                String IncidentDate =
                    DateFormat('yyyy-MM-dd kk:mm:ss').format(now).toString();

                try {
                  updateDevice(_selectedStatusID!,
                      infoDevice[0]['EquipmentID'].toString());
                  insertNotification(
                      infoDevice[0]['EquipmentID'].toString(),
                      int.parse(widget.UserID),
                      IncidentDate,
                      _inforStatusEquipmentController.text,
                      _selectedStatusID!);
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    title: "Thành công",
                    desc: 'Bạn sửa thành công!',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                    btnCancelOnPress: () {},
                  ).show();
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

  Future<void> updateDevice(int status, String idDevice) async {
    await connectionDevice.updateDevice(status, idDevice);
    selecttDevice();
  }

  Future<void> insertNotification(
      String EquipmentID,
      int UserID,
      String IncidentDate,
      String IncidentDescription,
      int IncidentStatusID) async {
    await connectionNotification.addNotifications(EquipmentID, UserID,
        IncidentDate, IncidentDescription, IncidentStatusID);
  }
}
