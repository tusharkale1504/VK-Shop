import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vk_shop/services/db.dart';
import 'package:vk_shop/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking extends StatefulWidget {
  final String service;
  Booking({required this.service});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, image, email, phone;
  bool _isLoadingUser = true;

  Future<void> getUserData() async {
    try {
      name = await SharedpreferenceHelper().getUserName();
      image = await SharedpreferenceHelper().getUserImage();
      email = await SharedpreferenceHelper().getUserEmail();
      phone = await SharedpreferenceHelper().getUserPhone();
    } catch (e) {
      print("Error fetching user data: $e");
    }

    setState(() {
      _isLoadingUser = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<TimeOfDay> _appointments = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      if (picked.hour >= 9 && picked.hour <= 22) {
        if (!_appointments.contains(picked)) {
          setState(() {
            _selectedTime = picked;
            _appointments.add(picked);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Appointment: ${picked.format(context)}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This time is already booked.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Allowed only between 9:00 and 22:00.')),
        );
      }
    }
  }

  Future<void> _checkAndBookAppointment(BuildContext context) async {
    final safeEmail = email ?? "tushar@gmail.com";
    final safePhone = phone ?? "9325801228";
    final safeName = name ?? "Tushar";
    final safeImage = image ?? "";

    bool alreadyBooked = await DatabaseMethods().checkUserBooking(
      safeEmail,
      widget.service,
      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
      safePhone,
    );

    if (alreadyBooked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You already booked this service on this date.'),
        ),
      );
    } else {
      Map<String, dynamic> userBookingMap = {
        "service": widget.service,
        "bookingDate":
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
        "bookingTime": _selectedTime.format(context),
        "fullName": safeName,
        "profileImage": safeImage,
        "phoneNumber": safePhone,
        "email": safeEmail,
        "createdAt": FieldValue.serverTimestamp(),
        "status": "pending",
        "userId": "",
      };

      await DatabaseMethods()
          .addUserBooking(userBookingMap)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Appointment booked successfully 🎉",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error booking appointment: $e")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set system nav bar same color as gradient bottom
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF04526F),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    if (_isLoadingUser) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        extendBody: true, // ✅ gradient flows behind nav bar
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF04364F), Color(0xFF407C91), Color(0xFF04526F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
      
                  // Header
                  Text(
                    "Book Your\nAppointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
      
                  // Service Image
                  Center(
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: AssetImage("images/discount.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
      
                  // Service Title
                  Center(
                    child: Text(
                      widget.service,
                      style: TextStyle(
                        color: Colors.orange[300],
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
      
                  // Date Card
                  _buildSelectionCard(
                    title: "Select Date",
                    icon: Icons.calendar_today,
                    value:
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 20.0),
      
                  // Time Card
                  _buildSelectionCard(
                    title: "Select Time",
                    icon: Icons.access_time,
                    value: _selectedTime.format(context),
                    onTap: () => _selectTime(context),
                  ),
                  SizedBox(height: 30.0),
      
                  // Book Button
                  GestureDetector(
                    onTap: () => _checkAndBookAppointment(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 25.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFfe8f33), Color(0xFFfd6d20)],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          "Book Appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required String value,
    required Function() onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF04526F), size: 28.0),
              SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit_calendar, color: Colors.orange[400]),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
