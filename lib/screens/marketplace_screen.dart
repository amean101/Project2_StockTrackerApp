import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MarketplaceScreen extends StatelessWidget {
  Future<double> convertCurrency(double usd) async {
    final res = await http.get(
      Uri.parse('http://api.exchangeratesapi.io/v1/latest?access_key=YOUR_KEY'),
    );
    final rates = jsonDecode(res.body)['rates'];
    return usd * rates['EUR'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marketplace')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('artworks').snapshots(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final docs = snapshot.data.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final data = docs[i];
              return ListTile(
                leading: Image.network(data['imageUrl'], width: 50),
                title: Text(data['title']),
                subtitle: Text('\$${data['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
