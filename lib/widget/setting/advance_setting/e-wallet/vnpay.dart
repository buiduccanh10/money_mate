import 'package:flutter/material.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/qrcode.dart';

class vnpay extends StatefulWidget {
  const vnpay({super.key});

  @override
  State<vnpay> createState() => _vnpayState();
}

class _vnpayState extends State<vnpay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const qrcode()));
              },
              icon: const Icon(Icons.qr_code_scanner))
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}