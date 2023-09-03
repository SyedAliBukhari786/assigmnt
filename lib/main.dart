import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String errorText = '';
  String? selectedImagePath;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // User successfully signed up
        final uid = userCredential.user!.uid;
        // Upload the selected image to Firebase Storage
        if (selectedImagePath != null) {
          final Reference storageReference =
          FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
          await storageReference.putFile(File(selectedImagePath!));

          // Get the download URL of the uploaded image
          final String imageURL = await storageReference.getDownloadURL();

          // Store user data in Firestore
          await FirebaseFirestore.instance.collection('records').doc(uid).set({
            'username': usernameController.text,
            'imageURL': imageURL,
          });
        }
        setState(() {
          errorText = 'User signed up with ID: $uid';
        });
      } else {
        // Handle the case where userCredential.user is null
        setState(() {
          errorText = 'An error occurred during sign up. User data is null.';
        });
      }
    } catch (e) {
      // Handle specific Firebase Authentication exceptions
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          setState(() {
            errorText = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            errorText = 'The email address is already in use by another account.';
          });
        } else {
          setState(() {
            errorText = 'An error occurred during sign up: ${e.message}';
          });
        }
      } else {
        // Handle other non-Firebase exceptions
        setState(() {
          errorText = 'An unexpected error occurred during sign up: $e';
        });
      }
    }
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
      });
    } else {
      setState(() {
        errorText = 'No image selected.';
      });
    }
  }

  void validateAndSignUp() {
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
      setState(() {
        errorText = 'All fields are required.';
      });
    } else if (password.length < 8) {
      setState(() {
        errorText = 'Password must be at least 8 characters long.';
      });
    } else if (password != confirmPassword) {
      setState(() {
        errorText = 'Passwords do not match.';
      });
    } else {
      signUpWithEmailAndPassword(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: selectImage,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: selectedImagePath != null
                      ? Image.file(
                    File(selectedImagePath!),
                    width: 150,
                    height: 150,
                  )
                      : Image.asset(
                    'lib/admin.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter a username',
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: validateAndSignUp,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Sign up'),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text('Or continue with'),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'lib/facebook.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'lib/google.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'lib/apple-logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account ?'),
                  Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text(
                errorText,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
