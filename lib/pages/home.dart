import 'package:flutter/material.dart';
import 'package:vk_shop/pages/booking.dart';
import 'package:vk_shop/pages/my_bookings.dart';
import 'package:vk_shop/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image;
  final TextEditingController _searchController = TextEditingController();

  getthedatafromsharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    setState(() {});
  }

  getontheload() async {
    await getthedatafromsharedpref();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      {"title": "Shaving", "image": "images/shaving.png"},
      {"title": "Hair Wash", "image": "images/hair.png"},
      {"title": "Haircut", "image": "images/cutting.png"},
      {"title": "Beard Trim", "image": "images/beard.png"},
      {"title": "Facial Care", "image": "images/facials.png"},
      {"title": "Kids' Haircut", "image": "images/kids.png"},
    ];

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF04526F), Color(0xFF2C7C91)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Hello, ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              Text("👋",
                                  style: TextStyle(
                                    fontSize: 22,
                                  )),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(name ?? "Guest",
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: (image != null && image!.isNotEmpty)
                            ? NetworkImage(image!)
                            : AssetImage("images/profile.png") as ImageProvider,
                      )
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search for a service...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        icon: Icon(Icons.search, color: Colors.grey[700]),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
      
                // Categories (Horizontal Scroll)
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildCategoryChip("All"),
                      _buildCategoryChip("Hair"),
                      _buildCategoryChip("Beard"),
                      _buildCategoryChip("Kids"),
                      _buildCategoryChip("Facial"),
                    ],
                  ),
                ),
      
                SizedBox(height: 20),
      
                // Section Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Text(
                    "Our Services",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
      
                // Services Grid
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: services.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        String serviceName = services[index]["title"]!;
                        if (_searchController.text.isNotEmpty &&
                            !serviceName.toLowerCase().contains(
                                _searchController.text.toLowerCase())) {
                          return SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Booking(service: serviceName),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF04526F), Color(0xFF407C91)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  services[index]["image"]!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  serviceName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button for My Bookings
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xFFfd6d20),
          icon: Icon(Icons.calendar_month),
          label: Text("My Bookings"),
          onPressed: () {
      
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyBookings(),
              ),
            );
         
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFfe8f33), Color(0xFFfd6d20)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
