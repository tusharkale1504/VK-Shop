import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vk_shop/pages/onboarding.dart';
import 'firebase_options.dart'; // ✅ Important import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Add this line
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VK Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Onboarding(), // Directly load onboarding (Firebase already initialized)
    );
  }
}
