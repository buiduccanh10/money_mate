class income_cat {
  int? cat_id;
  String? name;
  String? icon;
  int? total;
  income_cat({required this.cat_id, required this.name, required this.icon,required this.total});

  static List<income_cat> list_income_cat() {
    return [
      income_cat(cat_id: 1, name: 'Salary', icon: '💵',total: 9120),
      income_cat(cat_id: 2, name: 'Business', icon: '🤝🏻',total: 3342),
      income_cat(cat_id: 3, name: 'Others', icon: '🗒️',total: 1200),
    ];
  }
}
