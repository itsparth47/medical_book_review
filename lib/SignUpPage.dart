import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();


  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.email, color: Colors.white),
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
                prefixIcon: Icon(Icons.lock, color: Colors.white),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                try {
                  final userCredential = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                    'name': _nameController.text,
                    'email': email,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Successful !')));
                  Navigator.pop(context);
                } catch (e) {
                  // Sign up failed
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Failed !')));
                }
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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
