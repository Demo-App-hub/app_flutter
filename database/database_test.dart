import 'package:mysql1/mysql1.dart';

class DatabaseManager {
  late MySqlConnection _connection;

  Future<void> openConnection() async {
    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: 'free02.123host.vn',
        user: 'ritbznff_anh1905',
        port: 3306,
        db: 'ritbznff_demo',
        password: 'Anh190502',
      ));
      print("Connected successfully");
      // Khi kết nối thành công, bạn có thể thực hiện các thao tác cơ sở dữ liệu ở đây
    } catch (e) {
      print("Error connecting: $e");
      // Rethrow the error to be caught by the caller if needed
      rethrow;
    }
  }

  // Add more methods here for database operations

  // Ensure the connection is closed when done
  Future<void> closeConnection() async {
    await _connection?.close();
    print("Connection closed");
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class Borrowing {
//   String deviceId;
//   String borrowerName;
//   DateTime borrowedDate;
//   DateTime dueDate;
//   DateTime returnedDate;

//   Borrowing({
//     required this.deviceId,
//     required this.borrowerName,
//     required this.borrowedDate,
//     required this.dueDate,
//     required this.returnedDate,
//   });
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Equipment Borrowing System',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BorrowingScreen(),
//     );
//   }
// }

// class BorrowingScreen extends StatefulWidget {
//   @override
//   _BorrowingScreenState createState() => _BorrowingScreenState();
// }

// class _BorrowingScreenState extends State<BorrowingScreen> {
//   List<Borrowing> borrowings = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Equipment Borrowing System'),
//       ),
//       body: ListView.builder(
//         itemCount: borrowings.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text('Device ID: ${borrowings[index].deviceId}'),
//             subtitle: Text('Borrower: ${borrowings[index].borrowerName}'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Hiển thị màn hình thêm mượn thiết bị
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddBorrowingScreen(),
//             ),
//           ).then((value) {
//             // Cập nhật danh sách mượn thiết bị sau khi quay trở lại từ màn hình thêm mượn thiết bị
//             if (value != null) {
//               setState(() {
//                 borrowings.add(value);
//               });
//             }
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddBorrowingScreen extends StatefulWidget {
//   @override
//   _AddBorrowingScreenState createState() => _AddBorrowingScreenState();
// }

// class _AddBorrowingScreenState extends State<AddBorrowingScreen> {
//   final _deviceIdController = TextEditingController();
//   final _borrowerNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Borrowing'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _deviceIdController,
//               decoration: InputDecoration(labelText: 'Device ID'),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: _borrowerNameController,
//               decoration: InputDecoration(labelText: 'Borrower Name'),
//             ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () {
//                 // Thêm mượn thiết bị và trả về kết quả cho màn hình trước
//                 Navigator.pop(
//                   context,
//                   Borrowing(
//                     deviceId: _deviceIdController.text,
//                     borrowerName: _borrowerNameController.text,
//                     borrowedDate: DateTime.now(),
//                     dueDate: DateTime.now().add(Duration(days: 7)),
//                     returnedDate: DateTime.now(),
//                   ),
//                 );
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }