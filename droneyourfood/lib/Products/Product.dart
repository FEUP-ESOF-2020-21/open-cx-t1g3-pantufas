class Product {
  String name, image = "images/404.png";
  String category;

  Product(this.name, this.image, this.category);

  @override
  String toString() {
    return 'Product: {name = $name, category = $category, image = $image}';
  }
}
