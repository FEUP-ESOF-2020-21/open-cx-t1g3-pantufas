class Product {
  String name, image = "images/404.png";
  String category;

  Product(this.name, this.image, this.category);

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   Product res = new Product(
  //       id: json['id'], name: json['name'], image: 'images/' + json['image']);
  //   res.categories = new List();
  //
  //   for (String category in json['category']) {
  //     res.addCategory(category);
  //   }
  //
  //   return res;
  // }

  @override
  String toString() {
    return 'Product: {name = $name, category = $category, image = $image}';
  }
}
