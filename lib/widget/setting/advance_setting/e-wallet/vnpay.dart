import 'package:flutter/material.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/qrcode.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

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
            final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
              url:
                  'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
              version: '2.0.1', //version of VNPAY, default is 2.0.1
              tmnCode: 'KYQN0C6O', //vnpay tmn code, get from vnpay
              txnRef: DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(), //ref code, default is timestamp
              orderInfo: 'Pay 30.000 VND', //order info, default is Pay Order
              amount: 30000, //amount
              returnUrl:
                  'https://abc.com/return', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
              ipAdress: '171.225.205.182', //Your IP address
              vnpayHashKey:
                  'KGODIIQCAVJIAKAKGJRQYFDRZPSZCBFW', //vnpay hash key, get from vnpay
              vnPayHashType: VNPayHashType
                  .HMACSHA512, //hash type. Default is HmacSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2
            );
            VNPAYFlutter.instance.show(
              paymentUrl: paymentUrl,
              onPaymentSuccess: (params) {
                print(params);
              }, //on mobile transaction success
              onPaymentError: (params) {
                print(params);
              }, //on mobile transaction error
            );
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
