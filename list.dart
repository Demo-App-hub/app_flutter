// import 'package:flutter/material.dart';


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: CustomAppBar(),
//         drawer: CustomDrawer(), // Thêm CustomDrawer vào đây
//         body: Center(
//           child: Text('Nội dung màn hình'),
//         ),
//       ),
//     );
//   }
// }

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('Ứng dụng Flutter'),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             // Xử lý khi nút tìm kiếm được bấm
//             print('Nút tìm kiếm được bấm');
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             // Xử lý khi nút thêm mới được bấm
//             print('Nút thêm mới được bấm');
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Text(
//               'Menu',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text('Mục menu 1'),
//             onTap: () {
//               // Xử lý khi mục menu 1 được chọn
//               print('Mục menu 1 được chọn');
//               Navigator.pop(context); // Đóng Drawer
//             },
//           ),
//           ListTile(
//             title: Text('Mục menu 2'),
//             onTap: () {
//               // Xử lý khi mục menu 2 được chọn
//               print('Mục menu 2 được chọn');
//               Navigator.pop(context); // Đóng Drawer
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }