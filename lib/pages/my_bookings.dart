import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vk_shop/services/shared_pref.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  String? email;
  bool isLoading = true;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

 Future<void> fetchBookings() async {
  setState(() => isLoading = true);

  String? userEmail = await SharedpreferenceHelper().getUserEmail();
  userEmail = userEmail?.trim().toLowerCase();

  if (userEmail == null || userEmail.isEmpty) {
    print("❌ No user email found in SharedPreferences.");
    setState(() {
      bookings = [];
      isLoading = false;
    });
    return;
  }

  print("🔍 Fetching bookings for email: $userEmail");



  try {
    Query query = FirebaseFirestore.instance
        .collection("Booking")
        .where("email", isEqualTo: userEmail);

    try {
      query = query.orderBy("createdAt", descending: true);
    } catch (e) {
      print("⚠️ Skipping orderBy(createdAt): $e");
    }

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      print("⚠️ No bookings found for $userEmail");
    } else {
      print("✅ Found ${snapshot.docs.length} bookings for $userEmail");
    }

    bookings = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print("📌 Booking Data: $data");
      return data;
    }).toList();
  } catch (e) {
    print("❌ Error fetching bookings: $e");
  }

  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Bookings"),
          centerTitle: true,
          backgroundColor: Color(0xFF04526F),
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: fetchBookings,
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Color(0xFF04526F)))
              : bookings.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Color(0xFF04526F), Color(0xFF2C7C91)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service Title + Status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      booking["service"] ?? "Unknown Service",
                                      style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        // color: _getStatusColor(
                                        //         booking["status"] ?? "pending")
                                            // .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        booking["status"] ?? "Pending",
                                        style: TextStyle(
                                          // color: _getStatusColor(
                                          //     booking["status"] ?? "pending"),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
      
                                // Date & Time
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      booking["bookingDate"] ?? "No Date",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      booking["bookingTime"] ?? "No Time",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
      
                                // Contact Info
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      booking["phoneNumber"] ?? "N/A",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 15),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.email,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      booking["email"] ?? "N/A",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset("images/empty.png", height: 180),
          SizedBox(height: 20),
          Text(
            "No Bookings Yet!",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(
            "Book your first service to see it here.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
