// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:money_mate/services/locales.dart';
// import 'package:money_mate/view_model/setting_view_model.dart';
// import 'package:money_mate/widget/setting/advance_setting/e-wallet/paypal.dart';
// import 'package:provider/provider.dart';

// class qrcode extends StatefulWidget {
//   const qrcode({super.key});

//   @override
//   State<qrcode> createState() => _qrcodeState();
// }

// class _qrcodeState extends State<qrcode> {
//   // File? _imgFile;

//   // void takeSnapshot() async {
//   //   final ImagePicker picker = ImagePicker();
//   //   final XFile? img = await picker.pickImage(
//   //     source: ImageSource.gallery,
//   //     maxWidth: 400,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<setting_view_model>(
//       builder: (BuildContext context, setting_vm, Widget? child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(LocaleData.paymentMethodQr.getString(context)),
//             actions: [
//               IconButton(
//                   onPressed: () {
//                     //takeSnapshot();
//                   },
//                   icon: const Icon(Icons.image))
//             ],
//           ),
//           body: MobileScanner(
//             //fit: BoxFit.contain,
//             controller: MobileScannerController(),
//             onDetect: (capture) {
//               setting_vm.onDetect(capture, context);
//             },
//           ),
//         );
//       },
//     );
//   }
// }
