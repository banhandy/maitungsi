class DetailList {
  String itemName;
  double value;

  DetailList({this.itemName, this.value});
}

class CategoryList {
  String category;
  double value;
  List<DetailList> detail = [];

  CategoryList({this.category, this.value, this.detail});
}

class MonthlyList {
  final int month;
  final int year;
  double value;

  MonthlyList({this.month, this.year, this.value});
}

class ItemList {
  final String name;
  final String category;

  ItemList({this.category, this.name});
}

class DailyDetailList {
  String itemName;
  double value;
  String category;

  DailyDetailList({this.itemName, this.category, this.value});
}
