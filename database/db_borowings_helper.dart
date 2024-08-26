import 'package:mysql1/mysql1.dart';

class MySQLConnectionBorowings {
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

  Future<void> addBorowings(
      String EquipmentID,
      String fullNameUser,
      String borowingDate,
      String returnedDate,
      String phoneNumberUser,
      String departmentUser) async {
    try {
      await openConnection();
      //Future<bool> kt = isClassExists(nameClass);
      // if(await kt){
      //   print("Class đã tồn tại!");
      // }else{
      // await openConnection();

      String s =
          '''INSERT INTO `borowings`( `EquipmentID`, `fullNameUser`, `borowingDate`, `returnedDate`, `phoneNumberUser`, `departmentUser`, `StatusBorowing`) VALUES('${EquipmentID}','${fullNameUser}','${borowingDate}','','${phoneNumberUser}','${departmentUser}', 1);''';
      print(s);
      await _connection!.query(s);
      // }
    } catch (e) {
      print(e);
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllBorowingsFalse() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT user.UserID, user.FullName, category.CategoryName, EquipmentIncident.IncidentDate, EquipmentStatus.StatusName 
          FROM `equipment` INNER JOIN category ON equipment.CategoryID = category.CategoryID 
          INNER JOIN EquipmentStatus ON EquipmentStatus.StatusID = equipment.StatusID 
          INNER JOIN EquipmentIncident ON EquipmentIncident.EquipmentID = equipment.EquipmentID 
          INNER JOIN user ON user.UserID = EquipmentIncident.UserID;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'UserID': i[0],
          'FullName': i[1],
          'CategoryName': i[2],
          'IncidentDate': i[3],
          'StatusName': i[4],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> queryStatus(String EquipmentID) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String text =
          '''SELECT `StatusBorowing` FROM `borowings` WHERE `EquipmentID` = ${EquipmentID};''';
      Results results = await _connection!.query(text);

      // ignore: unused_local_variable
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'StatusBorowing': i[0],
        };
        list.add(deviceData);
      }
      return list;
    } catch (e) {
      return [];
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
  Future<List<Map<String, dynamic>>> getAllBorrwings() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT equipment.EquipmentID, category.CategoryName, fullNameUser, StatusBorowing, borowingDate , EquipmentLocation.EquipmentLocationName, borowings.departmentUser, EquipmentStatus.StatusName FROM borowings
          INNER JOIN equipment ON equipment.EquipmentID = borowings.EquipmentID 
          INNER JOIN category ON equipment.CategoryID = category.CategoryID 
          INNER JOIN EquipmentLocation ON equipment.EquipmentLocationID  = EquipmentLocation.EquipmentLocationID 
          INNER JOIN EquipmentStatus ON equipment.StatusID  = EquipmentStatus.StatusID  
          WHERE StatusBorowing = 1;''';
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'fullNameUser': i[2],
          'StatusBorowing': i[3],
          'borowingDate': i[4],
          'EquipmentLocationName': i[5],
          'departmentUser': i[6],
          'StatusName': i[7],
        };
        list.add(deviceData);
      }

      return list;
    } catch (e) {
      return [];
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> isExistsBorrwing(
      String EquipmentID) async {
    try {
      List<Map<String, dynamic>> list = [];
      // Mở kết nối tới MySQL
      await openConnection();
      String text =
          '''SELECT category.CategoryName, fullNameUser, StatusBorowing , borowings.EquipmentID
      FROM borowings 
      INNER JOIN equipment ON equipment.EquipmentID = borowings.EquipmentID 
      INNER JOIN category ON equipment.CategoryID = category.CategoryID 
      WHERE borowings.EquipmentID = ${EquipmentID} AND StatusBorowing = 1;''';
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'CategoryName': i[0],
          'fullNameUser': i[1],
          'StatusBorowing': i[2],
          'EquipmentID': i[3],
        };
        list.add(deviceData);
      }

      return list;
    } catch (e) {
      return [];
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }

  Future<bool> UpdateStatusBorrwings(
      String EquipmentID, String returnedDate) async {
    try {
      await openConnection();
      // Use the _connection for database operations
      await _connection!.query(
          '''UPDATE `borowings` SET `StatusBorowing`= 0, `returnedDate`='${returnedDate}' WHERE EquipmentID = ${EquipmentID} AND StatusBorowing = 1''');
      return true;
    } catch (e) {
      return false;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> isClassExists(String nameCategory) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();

      String a =
          "SELECT * FROM `category` WHERE `CategoryName` = '${nameCategory}'";
      //print(a);
      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var result = await _connection!.query(a);

      // Nếu có ít nhất một kết quả trả về, dữ liệu tồn tại
      print(result.isNotEmpty);
    } catch (e) {
      print('Error: $e');
      //return false;
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }
}
