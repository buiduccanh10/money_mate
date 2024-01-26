import 'package:flutter/material.dart';
import 'package:money_mate/model/income_cat.dart';
import 'package:money_mate/model/outcome_cat.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  List<outcome_cat> outcome_categories = outcome_cat.list_outcome_cat();
  List<income_cat> income_categories = income_cat.list_income_cat();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting page')),
    );
  }
}
