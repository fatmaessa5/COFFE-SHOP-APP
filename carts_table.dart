class CartsTable{
  String? userId;
  int? idCart;
  int? idProduct;
  int? quantity;

  CartsTable({
    this.userId,
    this.idCart,
    this.idProduct,
    this.quantity
  });


  CartsTable.fromJson(Map<String, dynamic> map) {
    userId = map['userId'];
    idCart = map['idCart'];
    idProduct = map['idProduct'];
    quantity = map['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['userId'] = this.userId;
    map['idCart'] = this.idCart;
    map['idProduct'] = this.idProduct;
    map['quantity'] = this.quantity;
    return map;
  }



}