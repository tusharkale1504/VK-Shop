import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vk_shop/pages/home.dart';
import 'package:vk_shop/pages/login.dart';
import 'package:vk_shop/services/db.dart';
import 'package:vk_shop/services/shared_pref.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SignUpState();
}

class _SignUpState extends State<SingUp> {
  String? name, mail, phone, password;

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  bool _isRecaptchaVerified = false;

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && mail != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail!, password: password!);

        String id = randomAlphaNumeric(10);
        await SharedpreferenceHelper().saveUserName(namecontroller.text);
        await SharedpreferenceHelper().saveUserEmail(emailcontroller.text);
        await SharedpreferenceHelper().saveUserPhone(phonecontroller.text);
        await SharedpreferenceHelper().saveUserImage(
            "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");
        await SharedpreferenceHelper().saveUserId(id);

        Map<String, dynamic> userInfoMap = {
          "fullName": namecontroller.text,
          "email": emailcontroller.text,
          "phoneNumber": phonecontroller.text,
          "userId": id,
          "profileImageUrl":
              "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a"
        };

        await DatabaseMethods().addUserDetails(userInfoMap, id);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Your membership has been created successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "The password you entered is too weak",
            style: TextStyle(fontSize: 20.0),
          )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "You already have an account, please log in.",
            style: TextStyle(fontSize: 20.0),
          )));
        }
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
              // Top gradient background
              Container(
                padding: EdgeInsets.only(top: 50.0, left: 30.0),
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 4, 82, 111),
                    Color.fromARGB(255, 65, 130, 154),
                    Color.fromARGB(255, 4, 82, 111),
                  ]),
                ),
                child: Text(
                  "Start your membership!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // White card with form
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5,
                ),
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 82, 111),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your full name'
                                : null,
                        controller: namecontroller,
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 82, 111),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your email address'
                                : null,
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          hintText: "Enter your email address",
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Phone",
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 82, 111),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your phone number'
                                : null,
                        controller: phonecontroller,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 82, 111),
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please choose a strong password'
                                : null,
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Choose a strong password",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),

                      Spacer(), // Pushes Sign Up button to bottom

                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              mail = emailcontroller.text;
                              name = namecontroller.text;
                              password = passwordcontroller.text;
                            });
                            registration();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 4, 82, 111),
                              Color.fromARGB(255, 35, 104, 130),
                              Color.fromARGB(255, 4, 82, 111),
                            ]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn()),
                              );
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                color: Color.fromARGB(255, 4, 82, 111),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
