class Category {
  String name;
  int money;

  Category({this.name, this.money});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    money = json['money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['money'] = this.money;
    return data;
  }
}
