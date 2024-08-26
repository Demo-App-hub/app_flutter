import 'dart:async';
import 'dart:math';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:demo_app_01_02/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String setRandomOtp() {
    // Tạo một số nguyên ngẫu nhiên từ 100000 đến 999999 làm mã OTP
    int randomSixDigitNumber = 100000 + Random().nextInt(900000);
    return randomSixDigitNumber.toString();
  }

  Future<void> sentOptInEmail(String otp, String email) async {
    final username =
        'demoapp20232024@gmail.com'; // Thay bằng địa chỉ email của bạn
    final appPassword =
        'kmsv zjvc pxlf zcuy'; // Thay bằng mã xác minh ứng dụng bạn đã tạo
    final smtpServer = gmail(username, appPassword);

    // // URL của trang web động bạn muốn chèn vào email (ví dụ: trang web có thể được nhúng qua thẻ iframe)

    // // Tạo đối tượng Message và sử dụng cascade notation
    final message = Message()
      ..from = Address(username, 'App demo')
      ..recipients.add(email)
      ..subject = 'OTP Verification Code'
      ..html = '''
        <p>This is the account registration confirmation code:</p>
        <p><strong>$otp</strong></p>
        <p>Please send us your feedback at <a href="https://forms.gle/qqARK2Rz6PsL2Xuy8" style="text-decoration: none;">Demo app 2023-2024</a></p>
      ''';
    try {
      // Gửi email
      final sendReport = await send(message, smtpServer);
      // In ra thông báo kết quả
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendResetCode(BuildContext context) async {
    try {
      String email = emailController.text;

      // Kiểm tra xem email có tồn tại trong database hay không
      bool isEmailExist = await isEmailInDatabase(email);

      if (isEmailExist) {
        // Nếu email tồn tại, gửi mã xác nhận
        String otp = setRandomOtp();
        print("=========================================================");
        print(email);
        print(otp);
        print("=========================================================");
        final username =
            'demoapp20232024@gmail.com'; // Thay bằng địa chỉ email của bạn
        final appPassword =
            'kmsv zjvc pxlf zcuy'; // Thay bằng mã xác minh ứng dụng bạn đã tạo
        final smtpServer = gmail(username, appPassword);
        final message = Message()
          ..from = Address(username, 'App demo')
          ..recipients.add(email)
          ..subject = 'OTP Verification Code'
          ..html = '''
              <p>This is the account registration confirmation code:</p>
              <p><strong>$otp</strong></p>
              <p>Please send us your feedback at <a href="https://forms.gle/qqARK2Rz6PsL2Xuy8" style="text-decoration: none;">Demo app 2023-2024</a></p>
            ''';
        try {
          // Gửi email
          final sendReport = await send(message, smtpServer);
          // In ra thông báo kết quả
          print('Message sent: ' + sendReport.toString());
        } catch (e) {
          print('Error: $e');
        }
        // Chuyển hướng đến màn hình xác nhận mã
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetCodeConfirmationScreen(
                  correctConfirmationCode: otp, email: email)),
        );
      } else {
        // Nếu email không tồn tại, hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Email không tồn tại. Vui lòng nhập email hợp lệ.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text(
                'Không gửi được email đặt lại mật khẩu. Vui lòng kiểm tra email của bạn và thử lại.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> isEmailInDatabase(String email) async {
    // Thực hiện truy vấn đến database để kiểm tra sự tồn tại của email
    final MySQLConnectionUser connectionUser = MySQLConnectionUser();
    Future<bool> check = connectionUser.isEmailExists(email);
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                sendResetCode(context);
              },
              child: Text('Kiểm tra'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetCodeConfirmationScreen extends StatefulWidget {
  final String correctConfirmationCode;
  final String email;
  ResetCodeConfirmationScreen(
      {required this.correctConfirmationCode, required this.email});

  @override
  _ResetCodeConfirmationScreenState createState() =>
      _ResetCodeConfirmationScreenState();
}

class _ResetCodeConfirmationScreenState
    extends State<ResetCodeConfirmationScreen> {
  final TextEditingController codeController = TextEditingController();
  late int remainingTime;
  late Timer timer;
  bool canResend = false;
  @override
  void initState() {
    super.initState();
    remainingTime = 60; // Thời gian đếm ngược là 60 giây
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel(); // Dừng đếm ngược khi hết thời gian
          canResend = true; // Cho phép gửi lại khi đã hết thời gian
        }
      });
    });
  }

  Future<void> confirmResetCode(BuildContext context) async {
    String enteredCode = codeController.text;

    if (enteredCode == widget.correctConfirmationCode) {
      // Mã nhập vào đúng
      // Thực hiện các bước tiếp theo, chẳng hạn như chuyển hướng đến màn hình cập nhật mật khẩu
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: widget.email)),
      );
    } else {
      // Mã nhập vào không đúng
      // Hiển thị thông báo hoặc thực hiện hành động phù hợp
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mã xác nhận sai. Vui lòng thử lại.'),
        ),
      );
    }
  }

  Future<void> resendConfirmationCode() async {
    if (canResend) {
      // Thực hiện logic gửi lại mã xác nhận
      // Cập nhật remainingTime và bắt đầu lại đếm ngược
      setState(() {
        remainingTime = 60;
        canResend = false; // Chặn gửi lại cho đến khi hết thời gian đếm ngược
        startTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác nhận mã'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Mã xác nhận',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => confirmResetCode(context),
              child: Text('Gửi lại mã xác nhận'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () =>
                  resendConfirmationCode(), // Gọi hàm resendConfirmationCode khi nhấn nút "Resend code 5s"
              child: Text('Gửi'),
            ),
            SizedBox(height: 8.0),
            Text(
              'Gửi lại sau ${remainingTime} giây',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel(); // Hủy timer khi widget bị hủy
    super.dispose();
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String
      email; // Pass email from ResetCodeConfirmationScreen to ResetPasswordScreen

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Kiểm tra xem mật khẩu mới và mật khẩu xác minh có trùng nhau không
    if (newPassword == confirmPassword || newPassword.length >= 6) {
      // Thực hiện cập nhật lại mật khẩu, có thể sử dụng dịch vụ đang dùng
      final MySQLConnectionUser connectionUser = MySQLConnectionUser();
      connectionUser.updatePassWord(widget.email, newPassword);
      // Hiển thị thông báo cập nhật thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thành công'),
            content: Text('Mật khẩu của bạn đã được cập nhật thành công.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Mật khẩu và mật khẩu xác minh không trùng nhau, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Mất khẩu không hợp lệ. Vui lòng thử lại.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => resetPassword(context),
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
