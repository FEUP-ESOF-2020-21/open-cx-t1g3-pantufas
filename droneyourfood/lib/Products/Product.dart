class Product {
  String name, image = "images/404.png";
  String category;
  int price;

  Product(this.name, this.image, this.category, this.price);

  @override
  String toString() {
    return 'Product: {name = $name, prive = $price, category = $category, image = $image}';
  }

  int getPrice(int quant) {
    return price * quant;
  }
}
