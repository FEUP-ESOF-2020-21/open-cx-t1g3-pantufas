import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name, image;
  DocumentReference category, ref;
  int price;

  Product(this.name, this.image, this.category, this.price, this.ref);

  int getPrice(int quant) {
    return price * quant;
  }

  @override
  String toString() {
    return 'Product: {name = $name, price = $price, category = $category, image = $image}';
  }

  @override
  bool operator ==(covariant Product o) {
    return hashCode == o.hashCode;
  }

  @override
  int get hashCode => ref.id.hashCode;
}
