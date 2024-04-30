import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_book/HomePage.dart';

import 'Constants.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _LoginLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              // keyboardType: TextInputType.number,
              // maxLength: 10,
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly
              // ],
              decoration: InputDecoration(
                counterText: "",
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.phone, color: Colors.white,),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.lock, color: Colors.white,),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                try {
                  setState(() {
                    _LoginLoading = true;
                  });
                  final userCredential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Login successful
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  print('User logged in: ${userCredential.user}');
                  name = userCredential.user?.uid ?? 'N/A';
                  setState(() {
                    _LoginLoading = false;
                  });
                } catch (e) {
                  // Login failed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect Credentials !')));
                  print('Login failed: $e');
                  setState(() {
                    _LoginLoading = false;
                  });
                }
              },
              child: _LoginLoading ? CircularProgressIndicator(color: Colors.black,) : Text('Login', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}