import 'package:flutter/material.dart';

class cat_edit extends StatelessWidget {
  int cat_id;
  cat_edit({super.key, required this.cat_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$cat_id'),
      ),
    );
  }
}
