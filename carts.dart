import 'package:coffeshop_flutter/products_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'carts_table.dart';
import 'database_coffee_menue.dart';

class Carts extends StatefulWidget {
  const Carts({super.key});

  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  @override
  late Future<List<CartsTable>?> productsFuture;

  bool isCart = true;

  late final uid;

  void initState() {
    super.initState();

    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    uid = user!.uid;

    print("UID FROM CARTS $uid");

    productsFuture = DatabaseCoffeeMenue.getCarts(uid);
  }

  void refreshCarts() {
    setState(() {
      productsFuture = DatabaseCoffeeMenue.getCarts(uid);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Carts Products"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CartsTable>?>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final carts = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 130 / 195,
                    ),
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      return FutureBuilder<Products?>(
                        future: DatabaseCoffeeMenue.getProduct(cart.idProduct),
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
                              return Center(child: Text("Product not found"));
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
                                      icon: Icon(
                                          Icons.remove_shopping_cart_outlined),
                                      color: Colors.orange,
                                      onPressed: () {
                                        if (isCart) {
                                          DatabaseCoffeeMenue.removeFromCart(
                                                  cart.idProduct!, uid)
                                              .then((_) {
                                            refreshCarts();
                                          });
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
                              "No carts details available.",
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text("No carts available.",
                          style: TextStyle(color: Colors.white)));
                }
              },
            ),
          ),
          Container(
            height: 60,
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onPressed: () {},
                child: Text("Buy")),
          ),
        ],
      ),
    ));
  }
}
