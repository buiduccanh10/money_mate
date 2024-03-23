import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/paypal.dart';

class qrcode extends StatefulWidget {
  const qrcode({super.key});

  @override
  State<qrcode> createState() => _qrcodeState();
}

class _qrcodeState extends State<qrcode> {
  File? _imgFile;

  void takeSnapshot() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
  }

  void extractValuesFromBarcode(String barcodeUrl) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.payment_method_qr.getString(context)),
        actions: [
          IconButton(
              onPressed: () {
                takeSnapshot();
              },
              icon: const Icon(Icons.image))
        ],
      ),
      body: MobileScanner(
        //fit: BoxFit.contain,
        controller: MobileScannerController(
          // facing: CameraFacing.back,
          // torchEnabled: false,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          //final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');

            Navigator.pop(context);
            Uri uri = Uri.parse(barcode.rawValue!);

            String? business = uri.queryParameters['business'];
            String? amount = uri.queryParameters['amount'];
            String? itemName = uri.queryParameters['item_name'];

            if (amount != null && itemName != null && business != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => paypal(
                          account_holder: business,
                          content_billing: itemName,
                          money: amount)));
            }
          }
        },
      ),
    );
  }
}
