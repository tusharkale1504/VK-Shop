import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Needed for checking email existence
import 'package:vk_shop/pages/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// ✅ Check if email exists in Firestore
  Future<bool> checkUserExists(String email) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection("users") // 🔹 Change to your collection name
          .where("email", isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();

      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      print("❌ Firestore check failed: $e");
      return false;
    }
  }

  void resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final email = mailController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("⏳ Checking email..."),
        duration: Duration(seconds: 2),
      ));

      bool exists = await checkUserExists(email);

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "No user found with this email address!",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
        return;
      }

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "✅ A password reset link has been sent to your email!",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "❌ Error: ${e.message}",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              // 🔹 Top Gradient Header
              Container(
                padding: EdgeInsets.only(top: 50.0, left: 30.0),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 4, 82, 111),
                    Color.fromARGB(255, 65, 130, 154),
                    Color.fromARGB(255, 4, 82, 111)
                  ]),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Reset Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // 🔹 Form Card
              Container(
                padding: EdgeInsets.only(
                    top: 40.0, left: 30.0, right: 30.0, bottom: 30.0),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: mailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter your email address",
                            prefixIcon: Icon(Icons.mail_outline)),
                      ),
                      SizedBox(height: 40.0),

                      // 🔹 Reset Button
                      GestureDetector(
                        onTap: resetPassword,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 4, 82, 111),
                                Color.fromARGB(255, 35, 104, 130),
                                Color.fromARGB(255, 4, 82, 111)
                              ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Reset My Password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),

                      // 🔹 Back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Or",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogIn()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Log in",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
