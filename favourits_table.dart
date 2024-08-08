class  FavouritesTable{
  String? userId;
  int? idFav;
  int? idProduct;

  FavouritesTable({
    this.userId,
    this.idFav,
    this.idProduct,
  });

  FavouritesTable.fromJson(Map<String, dynamic> map) {
    userId = map['userId'];
    idFav = map['idFav'];
    idProduct = map['idProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['userId'] = this.userId;
    map['idFav'] = this.idFav;
    map['idProduct'] = this.idProduct;
    return map;
  }

}