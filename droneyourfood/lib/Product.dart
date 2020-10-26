class Product {
    int id;
    String name, image="images/404.png";
    List<String> categories;

    //Product(String name, int id, String image, String category) {
        //this.name = name;
        //this.id = id;
        //this.image = image;
        //this.category = category;
    //}
    Product({this.id, this.name, this.image, this.categories});

    void addCategory(String category) {
        this.categories.add(category);
    }

    factory Product.fromJson(Map<String, dynamic> json) {
        Product res = new Product(id: json['id'], name: json['name'], image : 'images/' + json['image']);
        res.categories  = new List();

        for (String category in json['category']) {
            res.addCategory(category);
        }

        return res;
    }

    @override
    String toString() {
        return 'Product: {id = $id, name = $name, categories = $categories, image = $image}';
    }
}
