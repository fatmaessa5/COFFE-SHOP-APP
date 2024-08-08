class Products{
  int? id_product;
  String? product_name;
  String? price;
  String? imagUrl;

  Products({
    this.id_product,
    this.product_name,
    this.price,
    this.imagUrl,
  });


  Products.fromJson(Map<String, dynamic> map) {
    id_product = map['id_product'];
    product_name = map['product_name'];
    price = map['price'];
    imagUrl = map['imagUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id_product'] = this.id_product;
    map['product_name'] = this.product_name;
    map['price'] = this.price;
    map['imagUrl'] = this.imagUrl;
    return map;
  }

}
