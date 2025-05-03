import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> mockFavorites = [
    'Starry Night',
    'Sunset Landscape',
    'Minimalist Portrait',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites & Gallery')),
      body: ListView.builder(
        itemCount: mockFavorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text(mockFavorites[index]),
          );
        },
      ),
    );
  }
}
