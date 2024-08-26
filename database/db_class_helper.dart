import 'package:mysql1/mysql1.dart';

class MySQLConnectionClass {
  MySqlConnection? _connection;
  Future<void> openConnection() async {
    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: 'free02.123host.vn',
        user: 'ritbznff_anh1905',
        port: 3306,
        db: 'ritbznff_demo',
        password: 'Anh190502',
        // host: 'server1.webhostmost.com',
        // user: 'ivhjinpu_tuananh',
        // db: 'ivhjinpu_dbTest',
        // password: 'Anh190502',
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

  Future<void> addClass(
    String EquipmentLocationName,
  ) async {
    try {
      await openConnection();
      //Future<bool> kt = isClassExists(nameClass);
      // if(await kt){
      //   print("Class đã tồn tại!");
      // }else{
      await openConnection();

      String s =
          "INSERT INTO `EquipmentLocation`(`EquipmentLocationID`, `EquipmentLocationName`) VALUES ('','${EquipmentLocationName}');";
      print(s);
      await _connection!.query(s);
      print('Thêm thành công!');
      // }
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  // Future<void> updatePassWord(String email, String newPass) async {
  //   try {
  //     if(newPass.length < 6 || newPass.length > 20){
  //         print("Độ dài mật khẩu chưa đúng");
  //     }else{
  //       String s = "UPDATE `tbuser` SET `passWord` = '" + "${newPass}" + "' WHERE `tbUser`.`email` = '${email}';";
  //       await openConnection();
  //       print(s);
  //       await _connection!.query(s);
  //       print("Cập nhật thành công");
  //     }
  //   } finally {
  //     // Ensure the connection is closed when done
  //     await closeConnection();
  //   }
  // }
  Future<bool> deleteClass(String id) async {
    try {
      String s =
          "DELETE FROM `EquipmentLocation` WHERE `EquipmentLocationID` = '$id';";
      await openConnection();
      print(s);
      await _connection!.query(s);
      return true;
    } catch (e) {
      return false;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllClass() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      Results results = await _connection!.query(
          'SELECT * FROM `EquipmentLocation` ORDER BY `EquipmentLocation`.`EquipmentLocationID` ASC');

      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> classData = {
          'EquipmentLocationID': i[0],
          'EquipmentLocationName': i[1],
        };

        list.add(classData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<String> getNameClass(int idClass) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      Results results = await _connection!.query(
          'SELECT * FROM `EquipmentLocation` WHERE `EquipmentLocation`.`EquipmentLocationID` = ${idClass}');

      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> classData = {
          'EquipmentLocationID': i[0],
          'EquipmentLocationName': i[1],
        };
        list.add(classData);
      }
      print(list[0]['EquipmentLocationName']);
      return list[0]['EquipmentLocationName'].toString();
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<bool> isClassExists(String EquipmentLocationName) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();

      String a =
          "SELECT * FROM `EquipmentLocation` WHERE `EquipmentLocationName` = '${EquipmentLocationName}'";
      //print(a);
      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var result = await _connection!.query(a);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }
}
