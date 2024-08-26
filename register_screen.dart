import 'dart:math';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:demo_app_01_02/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  String confirmationCode = ''; // Mã xác nhận từ email

  bool isLoggedIn = false;
  bool _isValidEmail = true;
  bool _isValidPassWord = true;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText: _isValidEmail ? null : 'Lỗi email',
              ),
              onChanged: (value) {
                setState(() {
                  _isValidEmail = _validateEmail(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: _isObscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isObscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscurePassword = !_isObscurePassword;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _isObscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isObscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscureConfirmPassword = !_isObscureConfirmPassword;
                    });
                  },
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText:
                    _validatePasswordsMatch(confirmPasswordController.text)
                        ? null
                        : 'Mật khẩu không phù hợp',
              ),
              onChanged: (value) {
                setState(() {
                  // Kiểm tra sự khớp giữa mật khẩu nhập lại và mật khẩu đã nhập
                  _isValidPassWord = _validatePasswordsMatch(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: fullNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                prefixIcon: Icon(Icons.person),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Thực hiện đăng ký
                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;
                String fullName = fullNameController.text;
                bool isEmailExist = await isEmailInDatabase(email);
                // Kiểm tra xem hai mật khẩu có giống nhau hay không

                if ((!_isValidEmail) ||
                    (password.length < 6) ||
                    (!_isValidPassWord) ||
                    (fullName.length == 0)) {
                  print(_isValidEmail.toString() +
                      password.length.toString() +
                      _isValidPassWord.toString());
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Mật khẩu không khớp'),
                        content: Text(
                            'Mật khẩu không trùng khớp. Vui lòng nhập cùng một mật khẩu vào cả hai trường.'),
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
                  return; // Dừng xử lý nếu mật khẩu không khớp
                }
                if (isEmailExist) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('lỗi'),
                        content: Text(
                            'Email đã tồn tại. Vui lòng nhập email hợp lệ.'),
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
                } else {
                  // Thực hiện gửi mã xác nhận qua email
                  sendConfirmationCode(email);

                  // Sau khi gửi mã xác nhận, chuyển hướng đến màn hình nhập mã xác nhận
                  bool codeVerified = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmationCodeScreen(
                          confirmationCode: confirmationCode),
                    ),
                  );

                  // Kiểm tra mã xác nhận
                  if (codeVerified) {
                    // Nếu mã xác nhận đúng, thực hiện thêm dữ liệu vào cơ sở dữ liệu
                    await registerUser(email, password, fullName);
                  } else {
                    // Nếu mã xác nhận sai, hiển thị thông báo
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Mã xác nhận sai'),
                          content: Text(
                              'Mã xác nhận không chính xác. Đăng ký không thành công.'),
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
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }

  bool _setPasss(String pass1, String pass2) {
    return pass1 == pass2;
  }

  bool _validatePasswordsMatch(String confirmPassword) {
    return confirmPassword == passwordController.text;
  }

  bool _validateEmail(String email) {
    // Use a regular expression to check if the email is valid
    // You can customize this regular expression based on your requirements
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }

  bool isEmailValid(String email) {
    // Biểu thức chính quy để kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    // Kiểm tra xem email có đúng định dạng hay không
    return emailRegex.hasMatch(email);
  }

  void sendConfirmationCode(String email) {
    // Gửi mã xác nhận qua email
    // Thực hiện các bước gửi mã xác nhận ở đây

    // Mã xác nhận ở đây chỉ là một ví dụ, bạn cần thay thế bằng quá trình xác nhận thực tế
    confirmationCode = setRandomOtp();
    sentOptCreateUser(email, confirmationCode);
  }

  Future<void> sentOptCreateUser(String email, String otp) async {
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

  Future<bool> isEmailInDatabase(String email) async {
    // Thực hiện truy vấn đến database để kiểm tra sự tồn tại của email
    final MySQLConnectionUser connectionUser = MySQLConnectionUser();
    Future<bool> check = connectionUser.isEmailExists(email);
    return check;
  }

  String setRandomOtp() {
    // Tạo một số nguyên ngẫu nhiên từ 100000 đến 999999 làm mã OTP
    int randomSixDigitNumber = 100000 + Random().nextInt(900000);
    return randomSixDigitNumber.toString();
  }

  Future<void> registerUser(
      String email, String password, String fullName) async {
    // Thực hiện thêm dữ liệu vào cơ sở dữ liệu
    // Đặt logic thêm dữ liệu vào cơ sở dữ liệu của bạn ở đây
    final MySQLConnectionUser connectionUser = MySQLConnectionUser();
    connectionUser.addUser(
        '',
        email,
        password,
        fullName,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
        '0');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng ký thành công'),
          content:
              Text('Đăng ký của bạn thành công. Bây giờ bạn có thể đăng nhập.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ConfirmationCodeScreen extends StatefulWidget {
  final String confirmationCode;

  ConfirmationCodeScreen({required this.confirmationCode});

  @override
  _ConfirmationCodeScreenState createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình mã xác nhận'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nhập mã xác nhận được gửi tới email của bạn'),
            SizedBox(height: 16.0),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Mã xác nhận',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Xác nhận mã
                String enteredCode = codeController.text;

                // So sánh với mã đã được gửi đi
                if (enteredCode == widget.confirmationCode) {
                  // Mã xác nhận đúng, trả về true
                  Navigator.pop(context, true);
                } else {
                  // Mã xác nhận sai, trả về false
                  Navigator.pop(context, false);
                }
              },
              child: Text('Xác nhận '),
            ),
          ],
        ),
      ),
    );
  }
}
