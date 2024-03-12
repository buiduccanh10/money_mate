import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/setting/advance_setting/setup_in_ex_regular.dart';

class advance_setting extends StatelessWidget {
  const advance_setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(LocaleData.advanced_settings.getString(context))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => setup_in_ex_regular()));
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
                                LocaleData.fixed_in_ex.getString(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  LocaleData.fixed_in_ex_des.getString(context),
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
          ],
        ),
      ),
    );
  }
}
