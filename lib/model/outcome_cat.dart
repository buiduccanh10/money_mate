class outcome_cat {
  int? cat_id;
  String? name;
  String? icon;
  int? total;
  outcome_cat(
      {required this.cat_id,
      required this.name,
      required this.icon,
      required this.total});

  static List<outcome_cat> list_outcome_cat() {
    return [
      outcome_cat(cat_id: 1, name: 'Shopping', icon: '🛒', total: 1300),
      outcome_cat(cat_id: 2, name: 'Food', icon: '🍔', total: 1200),
      outcome_cat(cat_id: 3, name: 'Vegetable', icon: '🥬', total: 3700),
      outcome_cat(cat_id: 4, name: 'Clothes', icon: '👕', total: 4300),
      outcome_cat(cat_id: 5, name: 'Travel', icon: '🏖️', total: 7300),
      outcome_cat(cat_id: 6, name: 'Moving', icon: '🚘', total: 1300),
      outcome_cat(cat_id: 7, name: 'Others', icon: '🗒️', total: 1500),
    ];
  }
}
