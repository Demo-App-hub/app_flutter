import 'package:demo_app_01_02/database/database_test.dart';

class MyApp {
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<void> runApp() async {
    try {
      // Mở kết nối đến cơ sở dữ liệu
      await _databaseManager.openConnection();

      // Thực hiện các thao tác cơ sở dữ liệu cần thiết ở đây
      // Ví dụ:
      // await _databaseManager.querySomething();

    } finally {
      // Đảm bảo kết nối được đóng sau khi hoàn thành
      await _databaseManager.closeConnection();
    }
  }
}

void main() {
  final myApp = MyApp();
  myApp.runApp();
}