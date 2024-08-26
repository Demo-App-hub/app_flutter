import 'package:mysql1/mysql1.dart';

class MySQLConnectionStatus {
  MySqlConnection? _connection;
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
    } catch (e) {
      print(
          "Error connecting: $e"); // Rethrow the error to be caught by the caller
    }
  }

  Future<void> closeConnection() async {
    try {
      if (_connection != null) {
        print("Closed successfully");
        await _connection!.close();
      }
    } catch (e) {
      print("Error closing connection: $e");
      rethrow; // Rethrow the error to be caught by the caller
    }
  }

  Future<bool> isEDeviceExists(String EquipmentID) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();
      String a =
          "SELECT * FROM `equipment` WHERE `EquipmentID` = '${EquipmentID}'";
      //print(a);
      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var result = await _connection!.query(a);

      // Nếu có ít nhất một kết quả trả về, dữ liệu tồn tại
      return result.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }

  Future<void> updateDevice(String StatusID, String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `StatusIDStatusID` = '${StatusID}' WHERE `equipment`.`EquipmentID` = '${EquipmentID}';";
      await openConnection();
      print(s);
      await _connection!.query(s);
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> deleteDevice(String EquipmentID) async {
    try {
      String s =
          "DELETE FROM `equipment` WHERE `equipment`.`EquipmentID` = '$EquipmentID';";
      await openConnection();
      print(s);
      await _connection!.query(s);
      print("Xóa thành công");
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> updateIdClass(int CategoryID, String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `CategoryID` = '${CategoryID}' WHERE `equipment`.`EquipmentID` = '${EquipmentID}';";
      await openConnection();
      print(s);
      await _connection!.query(s);
      print("Xóa thành công");
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }
//   Future<bool> checkLogin(String email, String password) async {
//   try {
//       String query = "SELECT * FROM `tbuser` WHERE `email` = '${email}' AND passWord = '${password}'";;
//       await openConnection();
//       print(query);
//       Results result =  await _connection!.query(query);
//       return result.isNotEmpty;
//     } finally {
//       // Ensure the connection is closed when done
//       await closeConnection();
//     }
// }

  Future<List<Map<String, dynamic>>> getAllDevice() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          ''' SELECT `equipment`.`EquipmentID` , `equipment`.`CategoryID` , `equipment`.`Description`,
      `equipment`.`StatusID`,
      `category`.`CategoryName`  FROM `equipment` 
      CROSS JOIN `category` WHERE `equipment`.`CategoryID` = `category`.`CategoryID`;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryID': i[1],
          'Description': i[2],
          'EquipmentLocationID': i[3],
          'StatusID': i[4],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }
}
