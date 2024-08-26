import 'package:flutter/material.dart';

class InfoDeviceScreen extends StatelessWidget {
  final String qrCode;

  InfoDeviceScreen({required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin thiết bị'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thông tin từ mã QR:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              qrCode,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}