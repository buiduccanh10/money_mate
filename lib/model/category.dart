class CategoryModel {
  final String catId;
  final String icon;
  final String name;
  final bool isIncome;
  final double limit;

  CategoryModel({
    required this.catId,
    required this.icon,
    required this.name,
    required this.isIncome,
    required this.limit,
  });

  Map<String, dynamic> toMap() {
    return {
      'catId': catId,
      'icon': icon,
      'name': name,
      'isIncome': isIncome,
      'limit': limit,
    };
  }
}
