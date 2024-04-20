import 'package:money_mate/widget/input/input.dart';

class category_model {
  final String cat_id;
  final String icon;
  final String name;
  final bool is_income;

  category_model(
      {
      required this.cat_id,
      required this.icon,
      required this.name,
      required this.is_income});

  Map<String, dynamic> toMap() {
    return {
      'cat_id': cat_id,
      'icon': icon,
      'name': name,
      'is_income': is_income,
    };
  }
}
