import 'package:flutter/material.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/setup_in_ex_regular.dart';
import 'package:money_mate/widget/setting/advance_setting/limit_in_ex/setup_in_ex_limit.dart';

class AdvanceSetting extends StatelessWidget {
  const AdvanceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.advancedSettings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SetupInExRegular()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.auto_awesome_motion_outlined,
                              size: 30,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.fixedInEx,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  AppLocalizations.of(context)!.fixedInExDes,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SetupInExLimit()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 18),
                            child: Icon(
                              Icons.production_quantity_limits_rounded,
                              size: 30,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.settingLimitTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  AppLocalizations.of(context)!.settingLimitDes,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 0.0, bottom: 0),
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (builder) => const ewallet()));
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             children: [
            //               const Padding(
            //                 padding: EdgeInsets.only(left: 10.0, right: 18),
            //                 child: Icon(
            //                   Icons.payment,
            //                   size: 30,
            //                 ),
            //               ),
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     LocaleData.payByEWallet.getString(context),
            //                     style: const TextStyle(
            //                         fontWeight: FontWeight.w500, fontSize: 16),
            //                   ),
            //                   SizedBox(
            //                     width: 300,
            //                     child: Text(
            //                       LocaleData.payByEWalletDes
            //                           .getString(context),
            //                       style: const TextStyle(color: Colors.grey),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //           const Icon(Icons.navigate_next)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
