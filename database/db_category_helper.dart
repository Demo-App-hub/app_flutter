import 'package:mysql1/mysql1.dart';

class MySQLConnectionCategory {
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

  Future<void> addCategory(
    String nameCategory,
  ) async {
    try {
      await openConnection();
      //Future<bool> kt = isClassExists(nameClass);
      // if(await kt){
      //   print("Class đã tồn tại!");
      // }else{
      await openConnection();

      String s =
          "INSERT INTO `category`(`CategoryID`, `CategoryName`) VALUES ('','${nameCategory}');";
      print(s);
      await _connection!.query(s);
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
  Future<bool> isCategoryExists(String CategoryName) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();

      String a =
          "SELECT * FROM `category` WHERE `CategoryName` = '${CategoryName}'";
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

  Future<bool> deleteCategory(int categoryID) async {
    try {
      String s =
          "DELETE FROM `category` WHERE `category`.`CategoryID` = '$categoryID';";
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

  Future<List<Map<String, dynamic>>> getAllCategory() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      Results results = await _connection!.query('SELECT * FROM category');

      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> categoryData = {
          'CategoryID': i[0],
          'CategoryName': i[1],
        };
        list.add(categoryData);
      }

      return list;
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
