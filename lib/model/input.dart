import 'package:money_mate/widget/input/input.dart';

class input_model {
  final String id;
  final String date;
  final String description;
  final double money;
  final String cat_id;
  final bool is_income;

  input_model(
      {required this.id,
      required this.date,
      required this.description,
      required this.money,
      required this.cat_id,
      required this.is_income});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'money': money,
      'cat_id': cat_id,
      'is_income': is_income,
    };
  }
}
