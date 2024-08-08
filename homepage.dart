
import 'package:coffeshop_flutter/products_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authScreen.dart';
import 'database_coffee_menue.dart';
import 'details_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // List contentList=[
  //   {'product_name':"Black Coffee",'price':'10.00','imagUrl':"assets/1.jpg"},
  //   {'product_name':"Cold Coffee",'price':'20.00','imagUrl':"assets/2.jpg"},
  //   {'product_name':"Coffee",'price':'30.00','imagUrl':"assets/3.jpg"},
  //   {'product_name':"Espresso",'price':'70.00','imagUrl':"assets/4.jpg"},
  //   {'product_name':"Black Coffee",'price':'15.00','imagUrl':"assets/icecoffe-5.png"},
  //   {'product_name':"Cold Coffee",'price':'32.00','imagUrl':"assets/icecoffee-1.jpg"},
  //   {'product_name':"Coffee",'price':'18.00','imagUrl':"assets/icecoffee-2.jpg"},
  //   {'product_name':"Ice Coffee",'price':'40.00','imagUrl':"assets/icecoffee-3.jpg"},
  //   {'product_name':"Hot Coffee",'price':'16.00','imagUrl':"assets/icecoffee-4.png"},
  //   {'product_name':"Espresso",'price':'25.00','imagUrl':"assets/icecoffee-6.jpg"},
  // ];

  late Future<List<Products>?> productsFuture;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // String? uid;

  late final uid;
  late final email;

  void initState() {
    super.initState();

    // for(int i=0;i<contentList.length;i++){
    //   final product = Products.fromJson(contentList[i]);
    //   DatabaseCoffeeMenue.addProduct(product);
    // }

    // productsFuture = DatabaseCoffeeMenue.getProducts();

    productsFuture =
        DatabaseCoffeeMenue.searchInProducts(searchTextController.text);
    final User? user = auth.currentUser;
    uid = user!.uid;
    email = user!.email;
  }

  void refreshSerch() {
    setState(() {
      productsFuture =
          DatabaseCoffeeMenue.searchInProducts(searchTextController.text);
    });
  }

  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff28292A),
        actions: [
          Icon(
            Icons.notifications,
            color: Colors.grey,
            size: 30,
          ),
        ],
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      drawer: Drawer(
          child: Container(
        color: Color((0xff2F3031)),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      "assets/bg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Email : $email",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ListTile(
              title: Text(
                "homepage",
                style: TextStyle(color: Colors.orange),
              ),
              leading: Icon(Icons.home, color: Colors.orange),
              onTap: () {},
            ),
            ListTile(
              title: Text("Account", style: TextStyle(color: Colors.orange)),
              leading: Icon(Icons.account_box, color: Colors.orange),
              onTap: () {},
            ),
            ListTile(
              title: Text("Order", style: TextStyle(color: Colors.orange)),
              leading: Icon(Icons.shopping_basket, color: Colors.orange),
              onTap: () {},
            ),
            ListTile(
              title: Text("About Us", style: TextStyle(color: Colors.orange)),
              leading: Icon(Icons.quiz_outlined, color: Colors.orange),
              onTap: () {},
            ),
            ListTile(
              title: Text("Contact Us", style: TextStyle(color: Colors.orange)),
              leading: Icon(Icons.phone, color: Colors.orange),
              onTap: () {},
            ),
            ListTile(
              title: Text("SignOut", style: TextStyle(color: Colors.orange)),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.orange,
              ),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.clear();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Authscreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      )),
      body: Column(
        children: [
          Text(
            "It‘s a Great Day for Coffee",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff454648),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: searchTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Find Your Coffee',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.grey,
                ),
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xff454648)),
                ),
              ),
              onChanged: (text) {
                refreshSerch();
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<Products>?>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final products = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 130 / 195,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsContent(
                                id: product.id_product!,
                                name: product.product_name!,
                                price: product.price!,
                                imageUrl: product.imagUrl!,
                              ),
                            ),
                          );
                        },
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
                                product.imagUrl!,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                product.product_name!,
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
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text("No products available.",
                          style: TextStyle(color: Colors.white)));
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xff28292A),
    ));
  }
}
