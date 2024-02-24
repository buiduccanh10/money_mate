import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:money_mate/widget/setting/setting.dart';
import 'package:money_mate/widget/chart/chart_widget.dart';
import 'package:money_mate/widget/home/home_appbar.dart';
import 'package:money_mate/widget/home/home_list_item.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [home_appbar(), home_list_item()],
      ),
    );
  }
}
