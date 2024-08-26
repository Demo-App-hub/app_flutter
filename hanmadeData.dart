// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

// // / Flutter code sample for [DropdownButton.selectedItemBuilder].
// Map<String, String> nameDevice = <String, String>{
//   'Tất cả': 'Tất cả',
//   'Máy tính': 'Máy tính',
//   'Máy in': 'Máy in',
//   'Điều hòa': 'Điều hòa',
//   'Máy chiếu': 'Máy chiếu',
// };

// Map<String, String> nameClass = <String, String>{
//   "Phòng 1": "Phòng 1",
//   "Phòng 2": "Phòng 2",
//   "Phòng 3": "Phòng 3",
//   "Phòng 4": "Phòng 4",
//   "Phòng 5": "Phòng 5",
// };

// class HandMadeClass extends StatelessWidget {
//   HandMadeClass({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Scaffold(
//         appBar: AppBar(title: const Text('Chia phòng thủ công')),
//         body: const Center(child: HandMadeClassExample()),
//       ),
//     );
//   }
// }

// class HandMadeClassExample extends StatefulWidget {
//   const HandMadeClassExample({super.key});

//   @override
//   State<HandMadeClassExample> createState() => _HandMadeClassExampleState();
// }

// class _HandMadeClassExampleState extends State<HandMadeClassExample> {
//   String? selectedNameDevice = nameDevice.keys.first,
//       _nameDevice,
//       valueStatus,
//       selectNameClass = nameClass.keys.first,
//       valuaNameClass;
//   bool? isChecked;
//   int number = 0;
//   List<Map<String, dynamic>> _allData = [];
//   List<bool> checkedList = [];
//   List<Map<String, dynamic>> _selectData = [];
//   void _refreshData() async {
//     // final data = await SQLHelper.getAllDeviceClass();
//     // setState(() {
//     //   _allData = data;
//     //   checkedList = List<bool>.filled(_allData.length, false);
//     //   number = _allData.length.toInt();
//     // });
//   }

//   void _getNameDevice(String nameDevice) async {
//     // final data = await SQLHelper.getNameDevice(nameDevice);
//     checkedList = List<bool>.filled(_allData.length, false);
//     setState(() {
//       // _allData = data;
//       number = _allData.length.toInt();
//     });
//   }

//   void _getNameDeviceClass(String nameDevice) async {
//     // final data = await SQLHelper.getNameDeviceClass(nameDevice);
//     checkedList = List<bool>.filled(_allData.length, false);
//     setState(() {
//       // _allData = data;
//       number = _allData.length.toInt();
//     });
//   }

//   @override
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
//           new Row(
//             children: <Widget>[
//               new Container(
//                 child: new Flexible(
//                   child: new DropdownButton<String>(
//                     items: nameDevice.keys
//                         .map<DropdownMenuItem<String>>((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(item),
//                       );
//                     }).toList(),
//                     value: selectedNameDevice,
//                     onChanged: (_value) {
//                       // This is called when the user selects an item.
//                       setState(() {
//                         secondvaluechanged(_value);
//                         selectedNameDevice = _value!;
//                         _nameDevice = selectedNameDevice.toString();
//                         if (selectedNameDevice == "Tất cả") {
//                           _refreshData();
//                         } else {
//                           _getNameDeviceClass(selectedNameDevice.toString());
//                         }
//                       });
//                     },
//                     hint: Text("Tên thiết bị"),
//                     selectedItemBuilder: (BuildContext context) {
//                       return nameDevice.values.map<Widget>((String item) {
//                         // This is the widget that will be shown when you select an item.
//                         // Here custom text style, alignment and layout size can be applied
//                         // to selected item string.
//                         return Container(
//                           alignment: Alignment.centerLeft,
//                           constraints: const BoxConstraints(minWidth: 50),
//                           child: Text(
//                             item,
//                             style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         );
//                       }).toList();
//                     },
//                   ),
//                 ),
//               ),
//               new Container(
//                 child: new Flexible(
//                   child: new DropdownButton<String>(
//                     items: nameClass.keys
//                         .map<DropdownMenuItem<String>>((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(item),
//                       );
//                     }).toList(),
//                     value: selectNameClass,
//                     onChanged: (_value) {
//                       // This is called when the user selects an item.
//                       setState(() {
//                         secondvaluechanged1(_value);
//                         selectNameClass = _value!;
//                       });
//                     },
//                     hint: Text("Tên phòng"),
//                     selectedItemBuilder: (BuildContext context) {
//                       return nameClass.values.map<Widget>((String item) {
//                         // This is the widget that will be shown when you select an item.
//                         // Here custom text style, alignment and layout size can be applied
//                         // to selected item string.
//                         return Container(
//                           alignment: Alignment.centerLeft,
//                           constraints: const BoxConstraints(minWidth: 50),
//                           child: Text(
//                             item,
//                             style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         );
//                       }).toList();
//                     },
//                   ),
//                 ),
//               ),
//               new Container(
//                 child: Column(children: [
//                   Text(
//                     number.toString(),
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   Row(
//                     children: [
//                       TextButton(
//                           style: ButtonStyle(
//                             foregroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.blue),
//                           ),
//                           onPressed: () {
//                             // _add();
//                             print(number);
//                           },
//                           child: Icon(Icons.add)),
//                       TextButton(
//                         style: ButtonStyle(
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.blue),
//                         ),
//                         onPressed: () {
//                           if (number >= 1) {
//                             // _remove();
//                           }
//                           print(number);
//                         },
//                         child: Icon(Icons.remove),
//                       )
//                     ],
//                   )
//                 ]),
//               )
//             ],
//           ),
//           new Container(
//             child: Text("Bạn đang chọn '" +
//                 selectedNameDevice.toString() +
//                 "'" +
//                 "\nBạn đang chọn số lượng thiết bị là: " +
//                 number.toString()),
//           ),
//           new Container(
//               child: Expanded(
//                   child: ListView.builder(
//             itemCount: _allData.length,
//             itemBuilder: (context, index) {
//               return CheckboxListTile(
//                 title: Text(_allData[index]['nameDevice']),
//                 value: checkedList[index],
//                 onChanged: (value) {
//                   setState(() {
//                     checkedList[index] = value!;
//                     print(checkedList);
//                     for (var i = 0; i < checkedList.length; i++) {
//                       if (checkedList[i] == true) {
//                         _updateDevice(
//                             _allData[i]['idDevice'],
//                             _allData[i]['nameDevice'],
//                             _allData[i]['infoDevice'],
//                             _allData[i]['statusDevice'],
//                             _allData[i]['noteDevice'],
//                             selectNameClass.toString());
//                       }
//                     }
//                     _refreshData();
//                   });
//                 },
//               );
//             },
//           ))),
//           new Container(
//             child: Row(
//               children: <Widget>[
//                 Padding(padding: EdgeInsets.symmetric(vertical: 5)),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // final data = await SQLHelper.getAllDevice();
//                     // print(data);

//                     // print(selectNameClass.toString());

//                     // for (var i = 0; i < checkedList.length; i++) {
//                     //   if (checkedList[i] == true) {
//                     //   _updateDevice(
//                     //       _allData[i]['idDevice'],
//                     //       _allData[i]['nameDevice'],
//                     //       _allData[i]['infoDevice'],
//                     //       _allData[i]['statusDevice'],
//                     //       _allData[i]['noteDevice'],
//                     //       selectNameClass.toString());
//                     // }
//                     // }
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(builder: (context) => AutoClass()),
//                     // );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: Text(
//                       "Chia phòng",
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void secondvaluechanged(_value) {
//     setState(() {
//       valueStatus = _value;
//     });
//   }

//   void secondvaluechanged1(_value) {
//     setState(() {
//       valuaNameClass = _value;
//     });
//   }

//   Future<void> _updateDevice(
//       String idDevice,
//       String nameDevice,
//       String infoDevice,
//       String statusDevice,
//       String noteDevice,
//       String nameClass) async {
//     //   await SQLHelper.updateDevice(
//     //       idDevice.toString(),
//     //       nameDevice.toString(),
//     //       infoDevice.toString(),
//     //       statusDevice.toString(),
//     //       noteDevice.toString(),
//     //       nameClass.toString());
//     // }

//     void _add() {
//       setState(() {
//         if (number >= 0 && number < _allData.length) {
//           number++;
//         }
//       });
//     }

//     void _remove() {
//       setState(() {
//         if (number >= 1) {
//           number--;
//         }
//       });
//     }
//   }
// }
