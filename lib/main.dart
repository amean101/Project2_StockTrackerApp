import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proj2/screens/browse_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Marketplace',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BrowseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
