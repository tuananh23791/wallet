class Expense {
  String content;
  int total;
  String date;
  String category;

  Expense({this.content, this.total, this.date, this.category});

  Expense.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    total = json['total'];
    date = json['date'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['total'] = this.total;
    data['date'] = this.date;
    data['category'] = this.category;
    return data;
  }

  @override
  String toString() {
    return 'Expense{content: $content, total: $total, date: $date, category: $category}';
  }
}
