class InputModel {
  final String id;
  final String date;
  final String description;
  final double money;
  final String catId;
  final bool isIncome;

  InputModel({
    required this.id,
    required this.date,
    required this.description,
    required this.money,
    required this.catId,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'money': money,
      'catId': catId,
      'isIncome': isIncome,
    };
  }
}
