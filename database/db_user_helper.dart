import 'package:mysql1/mysql1.dart';

class MySQLConnectionUser {
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

  Future<bool> openConnectionMessage() async {
    try {
      openConnection();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addUser(
    String id,
    String email,
    String passWord,
    String fullName,
    String dateCreate,
    String role,
  ) async {
    try {
      await openConnection();
      Future<bool> kt = isEmailExists(email);
      if (await kt) {
        print("Email đã tồn tại!");
      } else {
        await openConnection();

        String s =
            "INSERT INTO `user`(`UserID`,`Email`, `Password`, `FullName`, `DateCreate`, `Role`) VALUES ('','$email', '$passWord', '$fullName', '$dateCreate', '$role');";
        print(s);
        await _connection!.query(s);
        print('Thêm thành công!');
      }
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> updatePassWord(String email, String newPass) async {
    try {
      if (newPass.length < 6 || newPass.length > 20) {
        print("Độ dài mật khẩu chưa đúng");
      } else {
        String s = "UPDATE `user` SET `PassWord` = '" +
            "${newPass}" +
            "' WHERE `user`.`Email` = '${email}';";
        await openConnection();
        print(s);
        await _connection!.query(s);
        print("Cập nhật thành công");
      }
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      String s = "DELETE FROM `user` WHERE `user`.`Email` = '$email';";
      await openConnection();
      print(s);
      await _connection!.query(s);
      print("Xóa thành công");
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<bool> checkLogin(String email, String password) async {
    try {
      String query =
          "SELECT * FROM `user` WHERE `Email` = '${email}' AND PassWord = '${password}'";
      ;
      await openConnection();
      Results result = await _connection!.query(query);
      print(result.isNotEmpty);
      return result.isNotEmpty;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getUserByEmailAndPassword(
      String email, String password) async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      String query =
          "SELECT `Email`, `Password`, `Role` FROM `user` WHERE `Email` = '${email}' AND `Password` = '${password}';";
      print(query);

      Results results = await _connection!.query(query);
      //print(results[].toString());
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database
        Map<String, dynamic> deviceData = {
          'Email': i[0],
          'Password': i[1],
          'Role': i[2],
        };

        list.add(deviceData);

        // if (results.isNotEmpty) {
        //   final row = results.first;
        //   return User(
        //     email: row['email']?.toString() ?? '', // Handle possible null value
        //     password: row['passWord']?.toString() ?? '', // Handle possible null value
        //     status: row['status'] ?? '', // Handle possible null value
        //   );
        // }
        // return null;
      }

      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<List<Map<String, dynamic>>> getAllUser() async {
    try {
      await openConnection();
      List<Map<String, dynamic>> list = [];
      // Use the _connection for database operations
      Results results = await _connection!.query('SELECT * FROM user');
      for (var i in results) {
        // Assuming that `i` is a List<dynamic> from the database

        Map<String, dynamic> deviceData = {
          'Email': i[1],
          'FullName': i[3],
          'DateCreate': i[4],
          'Role': (i[5] == 1 ? "Admin" : "User"),
        };
        list.add(deviceData);
      }
      return list;
    } finally {
      // Ensure the connection is closed when done
      await closeConnection();
    }
  }

  Future<bool> isEmailExists(String email) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();
      String a = "SELECT * FROM `user` WHERE `Email` = '${email}'";
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

  Future<Results> selectEmail(String email) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();
      String a = "SELECT * FROM `user` WHERE `Email` = '${email}'";
      //print(a);
      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var result = await _connection!.query(a);

      // Nếu có ít nhất một kết quả trả về, dữ liệu tồn tại
      return result;
    } catch (e) {
      print('Error: $e');
      // Nếu có lỗi, bạn có thể quyết định trả về một giá trị mặc định hoặc ném một exception
      // return someDefaultValue;
      throw Exception('Error occurred during email selection: $e');
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }

  Future<List<String>> getInfo(String email) async {
    try {
      // Mở kết nối tới MySQL
      await openConnection();

      String query = "SELECT * FROM `user` WHERE `Email` = '$email'";

      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var result = await _connection!.query(query);
      // Kiểm tra xem có kết quả trả về hay không
      if (result.isNotEmpty) {
        // Lấy dữ liệu từ kết quả và chuyển đổi thành List<String>
        List<String> list = [];

        for (var row in result) {
          for (var i in row) {
            list.add(i.toString());
          }
          //fullNameList.add(row['fullName'].toString());
        }
        return list;
      } else {
        // Trường hợp không tìm thấy email
        return [];
      }
    } catch (e) {
      // Xử lý lỗi tùy thuộc vào yêu cầu của bạn
      print('Error: $e');
      return []; // hoặc throw Exception('Thông báo lỗi'); tùy thuộc vào ngữ cảnh
    } finally {
      // Đảm bảo đóng kết nối khi kết thúc
      await closeConnection();
    }
  }

  Future<Results> authenticateUser(String email, String passWord) async {
    await openConnection();
    try {
      String a =
          "SELECT * FROM `user` WHERE `Email` = '${email}' AND `PassWord` = '${passWord}'";
      //print(a);
      // Thực hiện câu lệnh SELECT để kiểm tra sự tồn tại của dữ liệu
      var results = await _connection!.query(a);

      return results;
    } finally {
      await closeConnection();
    }
  }

  setState(Null Function() param0) {}
}
