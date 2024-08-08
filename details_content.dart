import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'carts_table.dart';
import 'database_coffee_menue.dart';
import 'favourits_table.dart';

class DetailsContent extends StatefulWidget {
  final int? id;
  final String? name;
  final String? price;
  final String? imageUrl;

  const DetailsContent({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    // required coffee
  });

  @override
  State<DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<DetailsContent> {
  int cnt = 0;
  bool isFav = false;

  bool isAddToCart = false;
  late final uId;

  late Future<List<FavouritesTable>?> productsFuture;

  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    uId = user!.uid;

    print("UID FROM DETAILS $uId");

    productsFuture = DatabaseCoffeeMenue.getFavourites(uId);
  }

  void _toggleFavorite() {
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double p=double.parse(widget.price!);
    double totalPrice = double.parse(widget.price!) * cnt;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.white,
              ),
            ),
            Image.asset(
              "${widget.imageUrl}",
              height: 300,
              width: 300,
            ),
            Text(
              "${widget.name}",
              style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${widget.price}",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "This is a deligiuos ${widget.name} . Enjoye your drink!",
              style: GoogleFonts.pacifico(color: Colors.grey, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.minimize,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (cnt == 0) {
                              cnt = 0;
                            } else {
                              cnt--;
                            }
                          });
                        },
                      ),
                      Text("$cnt",
                          style: TextStyle(
                              backgroundColor: Colors.grey,
                              color: Colors.white)),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            cnt++;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Volume: 60 ml",
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Color(0xff454648),
                    height: 50,
                    minWidth: 150,
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        isAddToCart = !isAddToCart;
                      });

                      if (isAddToCart) {
                        CartsTable cartsTable =
                            new CartsTable(idProduct: widget.id, userId: uId);

                        bool exist = await DatabaseCoffeeMenue.check(
                            "Carts", widget.id!, uId);

                        if (exist) {
                          DatabaseCoffeeMenue.addCart(cartsTable);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Add to Carts"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("ok")),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "product is already exist in cart page"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("ok")),
                                  ],
                                );
                              });
                          print("product is already exist in cart page");
                        }
                      } else {
                        CartsTable cartsTable =
                            new CartsTable(idProduct: widget.id, userId: uId);
                        DatabaseCoffeeMenue.removeFromCart(
                            cartsTable.idProduct!, uId);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Remove from Carts"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        // DatabaseCoffeeMenue.deleteFavourite(favouritesTable);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Text("ok")),
                                ],
                              );
                            });
                      }

                      // if(isAddToCart){
                      //   CartsTable cartsTable = new CartsTable(idProduct: widget.id ,userId: uId);
                      //
                      //   bool exist=await DatabaseCoffeeMenue.check(, uid);
                      //
                      //
                      //   DatabaseCoffeeMenue.addCart(cartsTable);
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: Text("Add to Carts"),
                      //           actions: [
                      //             ElevatedButton(
                      //                 onPressed: () {
                      //                   Navigator.pop(context);
                      //                   setState(() {});
                      //                 },
                      //                 child: Text("ok")),
                      //           ],
                      //         );
                      //       });
                      //
                      // }
                      //
                      // else{
                      //   CartsTable cartsTable = new CartsTable(idProduct: widget.id ,userId: uId );
                      //   DatabaseCoffeeMenue.removeFromCart(cartsTable);
                      //
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: Text("Remove from Carts"),
                      //           actions: [
                      //             ElevatedButton(
                      //                 onPressed: () {
                      //                   // DatabaseCoffeeMenue.deleteFavourite(favouritesTable);
                      //                   Navigator.pop(context);
                      //                   setState(() {});
                      //                 },
                      //                 child: Text("ok")),
                      //           ],
                      //         );
                      //       });
                      // }
                    },
                    child: Text("Add To Cart"),
                  ),

                  // ***********************************************************

                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffE57734),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_outline,
                      ),
                      color: isFav ? Colors.red : Colors.white,
                      onPressed: () async {
                        setState(() {
                          isFav = !isFav;
                        });

                        if (isFav) {
                          FavouritesTable favouritesTable = new FavouritesTable(
                              idProduct: widget.id, userId: uId);

                          bool exist = await DatabaseCoffeeMenue.check(
                              "Favourites", widget.id!, uId);

                          if (exist) {
                            DatabaseCoffeeMenue.addFavourite(favouritesTable);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Add to Favourits"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text("ok")),
                                    ],
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "product is already exist in fav page"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text("ok")),
                                    ],
                                  );
                                });
                            print("product is already exist in fav page");
                          }
                        } else {
                          FavouritesTable favouritesTable = new FavouritesTable(
                              idProduct: widget.id, userId: uId);
                          DatabaseCoffeeMenue.removeFavourite(
                              favouritesTable.idProduct!, uId);

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Remove from Favourits"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          // DatabaseCoffeeMenue.deleteFavourite(favouritesTable);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text("ok")),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
