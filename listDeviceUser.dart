// import 'package:demo_app_01/database/db_device_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// Map<String, String> nameDevice = <String, String>{
//   'Tất cả': 'Tất cả',
//   'Máy tính': 'Máy tính',
//   'Máy in': 'Máy in',
//   'Điều hòa': 'Điều hòa',
//   'Máy chiếu': 'Máy chiếu',
// };

// class ListDeviceUser extends StatelessWidget {
//   ListDeviceUser({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Scaffold(
//         appBar: AppBar(title: const Text('Danh sách thiết bị')),
//         body: const Center(child: ListDeviceExample()),
//       ),
//     );
//   }
// }

// class ListDeviceExample extends StatefulWidget {
//   const ListDeviceExample({super.key});

//   @override
//   State<ListDeviceExample> createState() => _ListDeviceExampleState();
// }

// class _ListDeviceExampleState extends State<ListDeviceExample> {
//   final MySQLConnectionDevice connectionDevice = MySQLConnectionDevice();
//   String? selectedNameDevice, valueStatus;
//   List<Map<String, dynamic>> _allData = [];
//   void _refreshData() async {
//     final List<Map<String, dynamic>> deviceList =
//         await connectionDevice.getAllDevice();
//     setState(() {
//       _allData = deviceList;
//     });
//   }

//   void _getNameDevice(String nameDevice) async {
//     final List<Map<String, dynamic>> deviceList =
//         await connectionDevice.getNameDevice(nameDevice);
//     setState(() {
//       _allData = deviceList;
//     });
//   }

//   // void _getNameDevice(String nameDevice) async {
//   //   final data = await SQLHelper.getNameDevice(nameDevice);
//   //   setState(() {
//   //     _allData = data;
//   //   });
//   // }

//   void iniState() {
//     super.initState();
//     _refreshData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       // mainAxisAlignment: MainAxisAlignment.center,
//       // mainAxisSize: MainAxisSize.max,
//       child: Column(
//         children: <Widget>[
//           new Container(
//             child: new Flexible(
//               child: new DropdownButton<String>(
//                 items: nameDevice.keys
//                     .map<DropdownMenuItem<String>>((String item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList(),
//                 value: selectedNameDevice,
//                 onChanged: (_value) {
//                   // This is called when the user selects an item.
//                   setState(() {
//                     secondvaluechanged(_value);
//                     selectedNameDevice = _value!;
//                     if (selectedNameDevice == "Tất cả") {
//                       _refreshData();
//                     } else {
//                       _getNameDevice(selectedNameDevice.toString());
//                     }
//                   });
//                 },
//                 hint: Text("Tên thiết bị"),
//                 selectedItemBuilder: (BuildContext context) {
//                   return nameDevice.values.map<Widget>((String item) {
//                     // This is the widget that will be shown when you select an item.
//                     // Here custom text style, alignment and layout size can be applied
//                     // to selected item string.
//                     return Container(
//                       alignment: Alignment.centerLeft,
//                       constraints: const BoxConstraints(minWidth: 50),
//                       child: Text(
//                         item,
//                         style: const TextStyle(
//                             color: Colors.blue, fontWeight: FontWeight.w600),
//                       ),
//                     );
//                   }).toList();
//                 },
//               ),
//             ),
//           ),
//           Container(
//               height: MediaQuery.of(context).size.height * 9 / 11,
//               child: Expanded(
//                 child: ListView.builder(
//                     itemCount: _allData.length,
//                     itemBuilder: (context, index) => Card(
//                         margin: EdgeInsets.all(15),
//                         child: Container(
//                             child: Column(children: <Widget>[
//                           ListTile(
//                             title: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 5),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       _allData[index]['nameDevice'].toString(),
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                     Text(
//                                         "ID: " +
//                                             _allData[index]['idDevice']
//                                                 .toString(),
//                                         style: TextStyle(fontSize: 15)),
//                                     Text(
//                                         "Tình trạng: " +
//                                             _allData[index]['statusDevice']
//                                                 .toString(),
//                                         style: TextStyle(fontSize: 15)),
//                                     Text("Phòng: " +
//                                         _allData[index]['nameClass']
//                                             .toString()),
//                                   ],
//                                 )),
//                           ),
//                         ])))),
//               )),
//         ],
//       ),
//     );
//   }

//   void secondvaluechanged(_value) {
//     setState(() {
//       valueStatus = _value;
//     });
//   }
// }
