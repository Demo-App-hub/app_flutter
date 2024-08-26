import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_app_01_02/adminHomeScreen.dart';
import 'package:demo_app_01_02/database/db_user_helper.dart';
import 'package:demo_app_01_02/forgot_password_screen.dart';
import 'package:demo_app_01_02/register_screen.dart';
import 'package:demo_app_01_02/src/authManager.dart';
import 'package:demo_app_01_02/userHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              LoginPage())); // Chuyển đến màn hình đăng nhập sau 3 giây
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Màu nền của màn hình splash
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.computer,
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 20.0),
            SpinKitThreeBounce(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Đang tải...',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MySQLConnectionUser connectionUser = MySQLConnectionUser();
  final AuthManager _authManager = AuthManager(); // Declare _authManager here

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // create();
    // checkConnect();
    //=================================================================================================================================
    _checkLoggedIn();
  }
  // Future<void> create() async {
  //   await connectionUser.createData();
  // }

  Future<void> _checkLoggedIn() async {
    String? storedEmail = await _authManager.getStoredEmail();
    String? storedPassword = await _authManager.getStoredPassword();
    if (storedEmail != null && storedPassword != null) {
      setState(() {
        _emailController.text = storedEmail;
        _passwordController.text = storedPassword;
        _rememberMe = true;
      });

      // Auto-login if there are stored credentials
      _loginAuto();
    }
  }

  Future<void> _loginAuto() async {
    try {
      //bool check = await connectionUser.checkLogin(_emailController.text, _passwordController.text);
      String email = _emailController.text;
      String password = _passwordController.text;

      // Save credentials for auto-login
      await _authManager.saveCredentials(email, password);
      // Save token instead of email and password
      if (_rememberMe) {
        await _authManager.setEmail(_emailController.text);
      }

      // Navigate based on user status
      List<Map<String, dynamic>> reslult =
          await connectionUser.getUserByEmailAndPassword(
              _emailController.text, _passwordController.text);

      int status = reslult[0]['Role'];
      print(status);
      if (status == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminHomeScreen(_authManager,
                  username: _emailController.text)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHomeScreen(_authManager,
                  username: _emailController.text)),
        );
      }
    } catch (e) {}
  }

  Future<void> checkLogin(String email, String password) async {
    try {
      print("EMAIL:${email}, Pass:${password}");
      bool check = await connectionUser.checkLogin(email, password);
      if (!check) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Đăng nhập thất bại'),
              content: Text('Sai tài khoản hoặc mật khẩu'),
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
        return;
      }

      // Save token instead of email and password
      if (_rememberMe) {
        await _authManager.saveCredentials(email, password);
      }

      // Navigate based on user status
      List<Map<String, dynamic>> reslult =
          await connectionUser.getUserByEmailAndPassword(
              _emailController.text, _passwordController.text);

      int status = reslult[0]['Role'];
      print("Giá trị : ${status}");
      if (status == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminHomeScreen(_authManager,
                  username: _emailController.text)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHomeScreen(_authManager,
                  username: _emailController.text)),
        );
      }
    } catch (e) {
      // Handle login error
      // print('Login error: $e');
    }
  }

  // Future<void> checkConnect() async {
  //   bool check = await connectionUser.openConnectionMessage();
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text((check == true) &&
  //                   !(connectivityResult == ConnectivityResult.none)
  //               ? "Pass"
  //               : "Failed"),
  //           content: Text("Database connection " +
  //               ((check == true) ? "pass!" : "failed!") +
  //               "\nInternet connection " +
  //               ((connectivityResult == ConnectivityResult.none) == true
  //                   ? "failed!"
  //                   : "pass!")),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       });
  // }
  // Future<void> checkInternetConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());

  //   if (connectivityResult == ConnectivityResult.none) {
  //     showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Failed connect internet'),
  //         content: Text("Can't connect internet"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();},
  //               child: Text('OK'),
  //               ),
  //             ],
  //           );
  //   }
  //   );

  //   } else {
  //     AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.warning,
  //       animType: AnimType.topSlide,
  //       showCloseIcon: true,
  //       title: "Cảnh báo",
  //       desc: 'Kết nối internet thành công!"',
  //       btnCancelOnPress: () {
  //         Navigator.pop(context);
  //       },
  //       btnOkOnPress: () {
  //         Navigator.pop(context);
  //       }).show();
  //   }
  // }

  Future<void> _logout() async {
    // Implement your logout logic here
    // Clear stored credentials
    await _authManager.removeCredentials();
    _passwordController.text = '';
    // Reset controllers to clear the input fields
  }

  bool isLoggedIn = false;
  bool _isValidEmail = true;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
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
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
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
            SizedBox(height: 20.0),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text('Ghi nhớ mật khẩu'),
              ],
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Xử lý đăng nhập ở đây
                String email = _emailController.text;
                String password = _passwordController.text;

                checkLogin(email, password);
              },
              child: Text('Đăng nhập'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Chuyển hướng đến màn hình đăng ký
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Đăng ký'),
                ),
                TextButton(
                  onPressed: () {
                    // Chuyển hướng đến màn hình quên mật khẩu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text('Quên mật khẩu?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
