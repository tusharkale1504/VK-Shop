import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vk_shop/Admin/booking_admin.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpassswordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 50.0,
                  left: 30.0,
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 4, 82, 111),
                  Color.fromARGB(255, 65, 130, 154),
                  Color.fromARGB(255, 4, 82, 111)
                ])),
                child: Text(
                  "Admin\nPanel",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                            color: Color.fromARGB(255, 4, 82, 111),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                            hintText: "Enter your username",
                            prefixIcon: Icon(Icons.mail_outline)),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 4, 82, 111),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: userpassswordcontroller,
                        decoration: InputDecoration(
                          hintText: "Choose a strong password",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          loginAdmin();
                        },
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
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          )),
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

 loginAdmin() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("Admin")
      .where("id", isEqualTo: usernamecontroller.text.trim())
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) {
    // No admin found
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Incorrect username", style: TextStyle(fontSize: 20.0))),
    );
    return;
  }

  final adminData = snapshot.docs.first.data();
  if (adminData['password'] != userpassswordcontroller.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Incorrect password!", style: TextStyle(fontSize: 20.0))),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingAdmin()),
    );
  }
}

}
