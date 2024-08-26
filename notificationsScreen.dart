import 'package:demo_app_01_02/database/db_notifications_helper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:demo_app_01_02/database/db_user_helper.dart';

class NotificationPage extends StatelessWidget {
  final String id;
  NotificationPage({Key? key, required this.id, required String UserID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: Center(
          child: NotificationScreen(
        UserID: id,
      )),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  final String UserID;
  NotificationScreen({
    required this.UserID,
  });

  @override
  __NotificationScreenExampleState createState() =>
      __NotificationScreenExampleState();
}

class __NotificationScreenExampleState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _allNotifications = [];
  final MySQLConnectionNotification connectionNotification =
      MySQLConnectionNotification();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    while (true) {
      final List<Map<String, dynamic>> notificationLists =
          await connectionNotification.getAllNotification();
      if (mounted) {
        setState(() {
          _allNotifications = notificationLists;
        });
      } else {
        // Nếu widget đã bị huỷ bỏ, dừng vòng lặp
        break;
      }

      await Future.delayed(Duration(seconds: 5));
      // Chờ 5 giây trước khi gọi lại hàm
    }
  }

  void _deleteItem(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (result ?? false) {
      try {
        // await connectionUser.deleteUser(_allDataUser[index]['id']);
        // _refreshData();
      } catch (e) {
        // Handle possible errors
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _deleteItem(index),
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.UserID ==
                                _allNotifications[index]['UserID'].toString()
                            ? "Bạn"
                            : _allNotifications[index]['FullName']
                                .toString()), // Assuming 'name' is a field
                        Text(
                          countingTime(_allNotifications[index]['IncidentDate']
                              .toString()), // This should be dynamically generated or removed if not relevant
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    subtitle: Text(
                        "Cập nhật trạng thái ${_allNotifications[index]['StatusName'].toString()} cho ${_allNotifications[index]['CategoryName'].toString()}"), // Assuming 'details' is a field
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _allNotifications.length,
            ),
          ),
        ],
      ),
    );
  }

  String countingTime(String timeDate) {
    DateTime endDate = DateTime.parse(timeDate).toLocal();
    // Thời điểm hiện tại
    DateTime now = DateTime.now();

    // Chuyển đổi thời điểm hiện tại sang cùng múi giờ với endDate

    // Tính khoảng thời gian từ endDate đến now
    Duration difference = now.difference(endDate);

    // Xử lý hiển thị kết quả
    String result = "";

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        // Nếu chỉ có phút
        result = "${difference.inMinutes} phút trước";
      } else {
        // Nếu chỉ có giờ và phút
        result = "${difference.inHours} giờ trước";
      }
      // Loại bỏ dấu trừ nếu có
      result = result.replaceAll("-", "");
    } else {
      // Nếu có ngày, hiển thị số ngày và chữ "trước"
      result = "${difference.inDays} ngày trước";
    }

    // In ra kết quả
    return result;
  }
}
