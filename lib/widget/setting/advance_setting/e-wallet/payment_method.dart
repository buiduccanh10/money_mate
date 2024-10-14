// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:money_mate/services/locales.dart';
// import 'package:money_mate/widget/setting/advance_setting/e-wallet/qrcode.dart';

// class payment_method extends StatelessWidget {
//   const payment_method({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(LocaleData.payment_method_title.getString(context)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Padding(
//             //   padding: const EdgeInsets.only(top: 0.0, bottom: 0),
//             //   child: InkWell(
//             //     onTap: () {
//             //       Navigator.push(context,
//             //           MaterialPageRoute(builder: (context) => const qrcode()));
//             //     },
//             //     child: Padding(
//             //       padding: const EdgeInsets.all(12.0),
//             //       child: Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //         children: [
//             //           Row(
//             //             children: [
//             //               const Padding(
//             //                   padding: EdgeInsets.only(right: 18),
//             //                   child: Icon(Icons.qr_code_scanner)),
//             //               Column(
//             //                 crossAxisAlignment: CrossAxisAlignment.start,
//             //                 children: [
//             //                   Text(
//             //                     LocaleData.payment_method_qr.getString(context),
//             //                     style: const TextStyle(
//             //                         fontWeight: FontWeight.w500, fontSize: 16),
//             //                   ),
//             //                 ],
//             //               ),
//             //             ],
//             //           ),
//             //           const Icon(Icons.navigate_next)
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             Padding(
//               padding: const EdgeInsets.only(top: 0.0, bottom: 0),
//               child: InkWell(
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           const Padding(
//                               padding: EdgeInsets.only(right: 18),
//                               child: Icon(Icons.person_add_alt_1)),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 LocaleData.payment_method_new
//                                     .getString(context),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500, fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const Icon(Icons.navigate_next)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
