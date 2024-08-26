import 'package:mysql1/mysql1.dart';

class MySQLConnectionDevice {
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

  Future<bool> addDevice(
    String EquipmentID,
    int CategoryID,
    String Description,
    // int EquipmentLocationID,
    int StatusID,
  ) async {
    try {
      await openConnection();
      bool kt = await isEDeviceExists(EquipmentID);
      print(
          "-------------------------------------------------------------------");
      print("Kiểm tra ${kt}");
      if (await kt) {
        return false;
      } else {
        await openConnection();
        String s =
            "INSERT INTO `equipment`(`EquipmentID`, `CategoryID`, `Description`, `EquipmentLocationID`, `StatusID`) VALUES ('${EquipmentID}','${CategoryID}','${Description}', '1','${StatusID}')";
        print(s);
        await _connection!.query(s);
        return true;
      }
    } catch (e) {
      return false;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<bool> isEDeviceExists(String EquipmentID) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();
      String a =
          "SELECT * FROM `equipment` WHERE `EquipmentID` = '${EquipmentID}'";
      print(a);
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

  Future<void> updateDevice(int StatusID, String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `StatusID` = '${StatusID}' WHERE `equipment`.`EquipmentID` = '${EquipmentID}';";
      await openConnection();
      print(s);
      await _connection!.query(s);
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> updateClassIDDevice(String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `EquipmentLocationID`= 0 WHERE EquipmentID = '${EquipmentID}'";
      await openConnection();
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

  Future<void> updateIdClass(
      int EquipmentLocationID, String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `EquipmentLocationID` = '${EquipmentLocationID}' WHERE `equipment`.`EquipmentID` = '${EquipmentID}';";
      await openConnection();
      print(s);
      await _connection!.query(s);
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> updateNumberEquipment(
      String NumberEquipment, String EquipmentID) async {
    try {
      String s =
          "UPDATE `equipment` SET `NumberEquipment` = '${NumberEquipment}' WHERE `equipment`.`EquipmentID` = '${EquipmentID}';";
      await openConnection();
      print(s);
      await _connection!.query(s);
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
          '''SELECT equipment.NumberEquipment,`equipment`.`EquipmentID` , `category`.`CategoryName` , `equipment`.`Description`, EquipmentStatus.StatusName,EquipmentLocation.EquipmentLocationName FROM `equipment` INNER JOIN `category` ON `equipment`.`CategoryID` = `category`.`CategoryID` INNER JOIN EquipmentStatus ON equipment.StatusID = EquipmentStatus.StatusID INNER JOIN EquipmentLocation ON equipment.EquipmentLocationID = EquipmentLocation.EquipmentLocationID ORDER BY EquipmentLocationName ASC;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'NumberEquipment': i[0],
          'EquipmentID': i[1],
          'CategoryName': i[2],
          'Description': i[3],
          'StatusName': i[4],
          'EquipmentLocationName': i[5],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllDevicesentEmail() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT `equipment`.`EquipmentID` , `category`.`CategoryName` , `equipment`.`Description`, 
          EquipmentStatus.StatusName,EquipmentLocation.EquipmentLocationName FROM `equipment` 
          INNER JOIN `category` ON `equipment`.`CategoryID` = `category`.`CategoryID` 
          INNER JOIN EquipmentStatus ON equipment.StatusID = EquipmentStatus.StatusID 
          INNER JOIN EquipmentLocation ON equipment.EquipmentLocationID = EquipmentLocation.EquipmentLocationID 
          ORDER BY EquipmentLocationName ASC;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'Description': i[2],
          'StatusName': i[3],
          'EquipmentLocationName': i[4],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getDeviceBorowingsSentEmail() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT borowingID, category.CategoryName, fullNameUser, borowingDate, returnedDate, 
          phoneNumberUser, departmentUser FROM borowings INNER JOIN equipment ON equipment.EquipmentID = borowings.EquipmentID 
          INNER JOIN category ON category.CategoryID = equipment.CategoryID;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'borowingID': i[0],
          'CategoryName': i[1],
          'fullNameUser': i[2],
          'borowingDate': i[3],
          'returnedDate': i[4],
          'phoneNumberUser': i[5],
          'departmentUser': i[6],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getDeviceIncidentSentEmail() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT equipment.EquipmentID,CategoryName, user.FullName, 
          EquipmentIncident.IncidentDate, EquipmentIncident.IncidentDescription 
          FROM `EquipmentIncident` INNER JOIN equipment ON equipment.EquipmentID = EquipmentIncident.EquipmentID 
          INNER JOIN category ON category.CategoryID = equipment.CategoryID INNER JOIN user ON user.UserID = EquipmentIncident.UserID;''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'FullName': i[2],
          'IncidentDate': i[3],
          'IncidentDescription': i[4],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllStatusDevice() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text = '''SELECT * FROM `EquipmentStatus`''';
      // Use the _connection for database operations      // Use the _connection for database operations
      Results results = await _connection!.query(text);

      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> categoryData = {
          'StatusID': i[0],
          'StatusName': i[1],
        };
        list.add(categoryData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllDeviceClass(
      int EquipmentLocationID) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // String text =
      //     ''' SELECT `tbdevice`.`idDevice` , `tbdevice`.`nameDevice` , `tbdevice`.`infoDevice`,
      // `tbdevice`.`statusDevice` , `tbdevice`.`noteDevice`,
      // `tbclass`.`nameClass`  FROM `tbdevice`
      // CROSS JOIN `tbclass` WHERE `tbdevice`.`idClass` = `tbclass`.`idClass` AND `tbdevice`.`idClass` = ${idClass};''';
      String text =
          '''SELECT equipment.NumberEquipment,equipment.EquipmentID, category.CategoryName, equipment.Description, EquipmentStatus.StatusName
              FROM `equipment` INNER JOIN category ON equipment.CategoryID = category.CategoryID  
              INNER JOIN EquipmentStatus ON EquipmentStatus.StatusID = equipment.StatusID
              WHERE `EquipmentLocationID` = ${EquipmentLocationID};''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'NumberEquipment': i[0],
          'EquipmentID': i[1],
          'CategoryName': i[2],
          'Description': i[3],
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

  // Future<List<Map<String, dynamic>>> getNameDeviceAndNameClass(
  //     String nameDevice, String nameClass) async {
  //   try {
  //     await openConnection();
  //     List<Map<String, dynamic>> list = [];
  //     Results? results;
  //     // Use the _connection for database operations
  //     if (nameDevice == 'Tất cả' || nameClass == 'Tất cả') {
  //       if (nameDevice == 'Tất cả' && nameClass == 'Tất cả') {
  //         String text =
  //             ''' SELECT `tbdevice`.`idDevice` , `tbdevice`.`nameDevice` , `tbdevice`.`infoDevice`,
  //        `tbdevice`.`statusDevice` , `tbdevice`.`noteDevice`,
  //         `tbclass`.`nameClass`  FROM `tbdevice`
  //         CROSS JOIN `tbclass` WHERE `tbdevice`.`idClass` = `tbclass`.`idClass`;''';
  //         results = await _connection!.query(text);
  //       } else if (nameClass == 'Tất cả') {
  //         String text =
  //             ''' SELECT `tbdevice`.`idDevice` , `tbdevice`.`nameDevice` , `tbdevice`.`infoDevice`,
  //        `tbdevice`.`statusDevice` , `tbdevice`.`noteDevice` AS 'Ghi chú',
  //         `tbclass`.`nameClass` AS 'Phòng' FROM `tbdevice`
  //         CROSS JOIN `tbclass` WHERE `tbdevice`.`idClass` = `tbclass`.`idClass` AND
  //         `tbdevice`.`nameDevice` = '${nameDevice}';''';
  //         results = await _connection!.query(text);
  //       } else if (nameDevice == 'Tất cả') {
  //         String text =
  //             ''' SELECT `tbdevice`.`idDevice` , `tbdevice`.`nameDevice` , `tbdevice`.`infoDevice`,
  //        `tbdevice`.`statusDevice` , `tbdevice`.`noteDevice` AS 'Ghi chú',
  //         `tbclass`.`nameClass` AS 'Phòng' FROM `tbdevice`
  //         CROSS JOIN `tbclass` WHERE `tbdevice`.`idClass` = `tbclass`.`idClass` AND
  //         `tbclass`.`nameClass` = '${nameClass}';''';
  //         results = await _connection!.query(text);
  //       }
  //     } else if (nameDevice != 'Tất cả' || nameClass != 'Tất cả') {
  //       String text =
  //           '''SELECT `tbdevice`.`idDevice` , `tbdevice`.`nameDevice` , `tbdevice`.`infoDevice`,
  //     `tbdevice`.`statusDevice` , `tbdevice`.`noteDevice` AS 'Ghi chú',
  //     `tbclass`.`nameClass` AS 'Phòng' FROM `tbdevice`
  //     CROSS JOIN `tbclass` WHERE `tbdevice`.`idClass` = `tbclass`.`idClass` AND
  //     `tbdevice`.`nameDevice` = '${nameDevice}' AND `tbclass`.`nameClass` = '${nameClass}';''';
  //       results = await _connection!.query(text);
  //     }

  //     for (var i in results!) {
  //       // Assuming that `i` is a List<dynamic> from the database
  //       Map<String, dynamic> deviceData = {
  //         'idDevice': i[0],
  //         'nameDevice': i[1],
  //         'infoDevice': i[2],
  //         'statusDevice': i[3],
  //         'noteDevice': i[4],
  //         'nameClass': i[5],
  //       };
  //       list.add(deviceData);
  //     }
  //     return list;
  //   } finally {
  //     // Ensure the connection is closed when done
  //     await closeConnection();
  //   }
  // }

  Future<List<Map<String, dynamic>>> getNameDevice(String CategoryName) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT equipment.EquipmentID, category.CategoryName, equipment.Description, EquipmentLocation.EquipmentLocationID, EquipmentStatus.StatusName
              FROM `equipment` INNER JOIN category ON equipment.CategoryID = category.CategoryID  
              INNER JOIN EquipmentStatus ON EquipmentStatus.StatusID = equipment.StatusID
              INNER JOIN EquipmentLocation ON EquipmentLocation.EquipmentLocationID = equipment.EquipmentLocationID
              WHERE `CategoryName` = ${CategoryName};''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'Description': i[2],
          'EquipmentLocationID': i[3],
          'StatusName': i[4],
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

  Future<List<Map<String, dynamic>>> getAllNameDevice() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      String text =
          '''SELECT equipment.EquipmentID, category.CategoryName, equipment.Description, EquipmentLocation.EquipmentLocationID, EquipmentStatus.StatusName
              FROM `equipment` INNER JOIN category ON equipment.CategoryID = category.CategoryID  
              INNER JOIN EquipmentStatus ON EquipmentStatus.StatusID = equipment.StatusID
              INNER JOIN EquipmentLocation ON EquipmentLocation.EquipmentLocationID = equipment.EquipmentLocationID''';
      // Use the _connection for database operations
      Results results = await _connection!.query(text);
      print(results);
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'Description': i[2],
          'EquipmentLocationID': i[3],
          'StatusName': i[4],
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

  Future<List<Map<String, dynamic>>> countEquipmentStatusOne(
      int EquipmentLocationID) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String text =
          '''SELECT COUNT(*) AS total FROM equipment WHERE StatusID = 1 AND EquipmentLocationID = ${EquipmentLocationID};''';
      Results results = await _connection!.query(text);

      // ignore: unused_local_variable
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'total': i[0],
        };
        list.add(deviceData);
      }
      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> countEquipmentStatus(
      int EquipmentLocationID) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String text =
          '''SELECT COUNT(*) AS total FROM equipment WHERE EquipmentLocationID = ${EquipmentLocationID};''';
      Results results = await _connection!.query(text);

      // ignore: unused_local_variable
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'total': i[0],
        };
        list.add(deviceData);
      }
      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getInfoDevice(String EquipmentID) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String text = '''
          SELECT `equipment`.`EquipmentID` , `category`.`CategoryName` , `equipment`.`Description`, 
          `EquipmentStatus`.`StatusName`, `EquipmentLocation`.`EquipmentLocationName`, `equipment`.`NumberEquipment`  FROM `equipment` 
          INNER JOIN `EquipmentLocation` ON `equipment`.`EquipmentLocationID` = `EquipmentLocation`.`EquipmentLocationID` 
          INNER JOIN EquipmentStatus ON EquipmentStatus.StatusID = equipment.StatusID 
          INNER JOIN category ON category.CategoryID = equipment.CategoryID WHERE equipment.EquipmentID = ${EquipmentID};
          ''';
      Results results = await _connection!.query(text);
      // ignore: unused_local_variable
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'EquipmentID': i[0],
          'CategoryName': i[1],
          'Description': i[2],
          'StatusName': i[3],
          'EquipmentLocationName': i[4],
          'NumberEquipment': i[5],
        };
        list.add(deviceData);
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getInfoEquipmentIncident() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String text = '''
          SELECT EquipmentIncident.IncidentID, category.CategoryName, `IncidentDate`, `IncidentDescription`,
           `IncidentStatusID` FROM `EquipmentIncident` INNER JOIN equipment ON EquipmentIncident.EquipmentID = equipment.EquipmentID 
           INNER JOIN category ON equipment.CategoryID = category.CategoryID;;
          ''';
      Results results = await _connection!.query(text);
      // ignore: unused_local_variable
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'IncidentID': i[0],
          'CategoryName': i[1],
          'IncidentDate': i[2],
          'IncidentDescription': i[3],
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
