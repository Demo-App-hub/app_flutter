import 'package:demo_app_01_02/loginScreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP DEMO 2024',
      home: LoginScreen(),
    );
  }
}

// import 'package:flutter/material.dart';

// Future<void> main() async {
//   runApp(MaterialApp(
//     home: MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String? _selectedDevice;
//   String? _selectedStatus;
//   final Map<String, List<String>> statusDevice = {
//     "Máy tính": ["Bình thường", "Hỏng RAM", "Hỏng màn hình", "Hỏng ổ cứng", "Hỏng bàn phím, chuột", "Hỏng nguồn", "Khác"],
//     "Máy in": ["Bình thường", "Bị treo", "Bản in mờ, chữ không nét và không đậm", "Không kéo được giấy", "Máy in bị kẹt mực", "Lỗi kết nối", "Khác"],
//     "Điều hòa": ["Bình thường", "Không chạy", "Điều hòa làm lạnh kém", "Điều hòa bị chảy nước", "Tự động tắt nguồn", "Máy không làm lạnh", "Khác"],
//     "Máy chiếu": ["Bình thường", "Hỏng nguồn", "Hỏng đường hình", "Không nhận máy tính", "Tự động tắt nguồn", "Không chiếu hết màn hình", "Khác"],
//   };
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown trong AlertDialog'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return StatefulBuilder(
//                   builder: (BuildContext context, setState) {
//                     return AlertDialog(
//                       title: Text('Chọn một mục'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           DropdownButton<String>(
//                               value: _selectedStatus,
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedStatus = newValue;
//                                 });
//                               },
//                               items: statusDevice["Điều hòa"]!.map((String status) {
//                                 return DropdownMenuItem<String>(
//                                   value: status,
//                                   child: Text(status),
//                                 );
//                               }).toList(),
//                             ),
//                         ],
//                       ),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('Đóng'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             );
//           },
//           child: Text('Hiển thị AlertDialog'),
//         ),
//       ),
//     );
//   }
// }