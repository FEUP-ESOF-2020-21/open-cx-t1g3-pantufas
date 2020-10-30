class Category {
  String name;
  List<Category> categories;

  Category({this.name, this.categories});

  factory Category.fromJson(Map<String, dynamic> json) {
    Category res;

    res = new Category(name: json['name'], categories: null);
    res.categories = new List();

    for (var category in json['subcategories']) {
      res.categories.add(Category.fromJson(category));
    }

    return res;
  }

  @override
  String toString() {
    return 'Category{name: $name, categories: $categories}';
  }
}
