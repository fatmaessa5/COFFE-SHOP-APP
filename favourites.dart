import 'package:coffeshop_flutter/products_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_coffee_menue.dart';
import 'favourits_table.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late Future<List<FavouritesTable>?> productsFuture;

  bool isFav = true;
  @override
  late final uid;

  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    uid = user!.uid;

    print("UID FROM FAV $uid");

    productsFuture = DatabaseCoffeeMenue.getFavourites(uid);
  }

  void refreshFavourites() {
    setState(() {
      productsFuture = DatabaseCoffeeMenue.getFavourites(uid);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Favourits Products"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<FavouritesTable>?>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final favourites = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 130 / 195,
                    ),
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      final favourite = favourites[index];
                      return FutureBuilder<Products?>(
                        future:
                            DatabaseCoffeeMenue.getProduct(favourite.idProduct),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            final product = snapshot.data;
                            if (product == null) {
                              return Center(
                                  child: Text("Product not found",
                                      style: TextStyle(color: Colors.white)));
                            }

                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff2F3031),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      product.imagUrl.toString(),
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      product.product_name.toString(),
                                      style: GoogleFonts.pacifico(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Best Coffee",
                                      style: GoogleFonts.pacifico(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "\$${product.price}",
                                      style: GoogleFonts.pacifico(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite),
                                      color: Colors.red,
                                      onPressed: () {
                                        DatabaseCoffeeMenue.removeFavourite(
                                                favourite.idProduct!, uid)
                                            .then((_) {
                                          refreshFavourites();
                                        });

                                        if (isFav) {
                                          // DatabaseCoffeeMenue.removeFavourite(favourite).then((_){
                                          //           refreshFavourites();
                                          // }
                                          // );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                                child: Text(
                              "No favourites details available.",
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text("No favourites available.",
                          style: TextStyle(color: Colors.white)));
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
