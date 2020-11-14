import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  DocumentReference ref;

  Category(this.name, this.ref);

  @override
  String toString() {
    return 'Category{name: $name}';
  }
}
