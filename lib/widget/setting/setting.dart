import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';

import 'package:money_mate/widget/setting/setting_content.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  final auth = FirebaseAuth.instance;
  String? user_name;
  String? image;

  @override
  void initState() {
    user_name = auth.currentUser!.email;
    image = auth.currentUser!.photoURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          const setting_content(),
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: is_dark
                    ? [
                        const Color.fromARGB(255, 0, 112, 204),
                        const Color.fromARGB(255, 203, 122, 0)
                      ]
                    : [Colors.orange, Colors.blue],
              ),
            ),
            child: SafeArea(
              maintainBottomViewPadding: true,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: image == null
                            ? const AssetImage('assets/avt.png')
                                as ImageProvider
                            : NetworkImage(image!),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: width * 0.8,
                          child: Text(
                            '${user_name}',
                            style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    color: is_dark ? Colors.grey[500] : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 18),
                                  child: Icon(
                                    Icons.edit_square,
                                    size: 26,
                                    color: Colors.black,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleData.modify.getString(context),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: is_dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      LocaleData.modify_des.getString(context),
                                      style: TextStyle(
                                          color: is_dark
                                              ? Colors.grey[10]
                                              : Colors.grey),
                                    )
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
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
