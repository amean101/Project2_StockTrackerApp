import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search artworks...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            style: const TextStyle(color: Colors.black),
            onChanged:
                (value) => setState(() {
                  _searchQuery = value.toLowerCase();
                }),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('artworks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading artworks'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results =
              snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                final title = data['title']?.toString().toLowerCase() ?? '';
                return title.contains(_searchQuery);
              }).toList();

          if (results.isEmpty) {
            return const Center(child: Text('No matching artworks found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final data = results[index].data() as Map<String, dynamic>? ?? {};
              final imageUrl = data['imageUrl']?.toString();
              final title = data['title']?.toString() ?? 'Untitled';
              final price =
                  (data['price'] as num?)?.toStringAsFixed(2) ?? '0.00';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading:
                      imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.broken_image),
                          )
                          : const Icon(Icons.image, size: 50),
                  title: Text(title),
                  subtitle: Text('\$$price'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
