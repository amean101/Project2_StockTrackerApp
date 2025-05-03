import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj2/auth_service.dart';
import 'package:proj2/screens/browse_screen.dart';
import 'package:proj2/screens/chat_screen.dart';
import 'package:proj2/screens/favorites_screen.dart';
import 'package:proj2/screens/search_screen.dart';
import 'package:proj2/screens/upload_screen.dart';

class HomeScreen extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Digital Art Marketplace!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UploadScreen()),
                  ),
              child: Text('Upload Artwork'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrowseScreen(onCartUpdate: (int) {}),
                    ),
                  ),
              child: Text('Browse Art'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen()),
                  ),
              child: Text('Chat with Artists'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoritesScreen()),
                  ),
              child: Text('Favorites & Gallery'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchScreen()),
                  ),
              child: Text('Search Art'),
            ),
          ],
        ),
      ),
    );
  }
}
