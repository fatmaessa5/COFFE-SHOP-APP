import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigatore_bar.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isCorrect = true;
  bool _isMessageAvailable = false;

  Future<void> _submit() async {
    try {
      if (_isLogin) {
        _isMessageAvailable = true;
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          _storeLoginStatus(true);

          Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => BottomNavigatoreBar()),
                (Route<dynamic> route) => false,
          );

        }

      } else {
        _isMessageAvailable = true;
        if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
          print("Passwords do not match");
          setState(() {
            _isCorrect = false;
          });
          return;
        }
        setState(() {
          _isCorrect = true;
        });
        UserCredential userCredential =  await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );


        if (userCredential.user != null) {
          _storeLoginStatus(true); // Store login status
        }

      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }


  Future<void> _storeLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {

      final FirebaseAuth auth = FirebaseAuth.instance;

      final User? user = auth.currentUser;
      final uid = user!.uid;
      final email =user!.email;

      print("UID $uid");
      print("EMAIL $email");


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigatoreBar() ));
    }
  }

  @override
  void initState() {
    super.initState();
    // _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.orange, // Set AppBar color to orange
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Text color in TextField
                      fillColor: Colors.grey[800], // Background color in TextField
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // Text color in TextField
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white), // Text color in TextField
                      fillColor: Colors.grey[800], // Background color in TextField
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white), // Text color in TextField
                  ),
                  SizedBox(height: 10),
                  if (!_isLogin)
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white), // Text color in TextField
                        fillColor: Colors.grey[800], // Background color in TextField
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // Text color in TextField
                    ),
                ],
              ),
            ),
            if (_isMessageAvailable)
              Text(
                _isCorrect ? "Register Successfully" : "Passwords do not match, try again.",
                style: TextStyle(
                  color: _isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 20),
              ),
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _isMessageAvailable = false; // Reset message visibility
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange, // Text color
              ),
              child: Text(_isLogin ? 'Create an account' : 'I already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}
