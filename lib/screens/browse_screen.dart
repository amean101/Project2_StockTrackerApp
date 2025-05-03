import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> _artworks = [];

  @override
  void initState() {
    super.initState();
    _loadArtworks();
  }

  Future<void> _loadArtworks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('artworks')
              .orderBy('timestamp', descending: true)
              .get();

      final artworks = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();

          if (data['imageUrl'] != null &&
              data['imageUrl'].toString().isNotEmpty) {
            return {...data, 'id': doc.id};
          }

          if (data['imagePath'] == null ||
              data['imagePath'].toString().isEmpty) {
            return {
              ...data,
              'imageUrl': null,
              'id': doc.id,
            }; // Skip image if no path
          }

          try {
            final imagePath = data['imagePath'];
            final url = await _storage.ref(imagePath).getDownloadURL();
            await doc.reference.update({'imageUrl': url});

            return {...data, 'imageUrl': url, 'id': doc.id};
          } catch (e) {
            debugPrint('Failed to fetch image URL for ${doc.id}: $e');
            return {...data, 'imageUrl': null, 'id': doc.id};
          }
        }),
      );

      setState(() => _artworks = artworks);
    } catch (e) {
      debugPrint('Error loading artworks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Art')),
      body:
          _artworks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: _artworks.length,
                itemBuilder: (context, index) {
                  final artwork = _artworks[index];
                  return ArtworkCard(artwork: artwork);
                },
              ),
    );
  }
}

class ArtworkCard extends StatelessWidget {
  final Map<String, dynamic> artwork;

  const ArtworkCard({required this.artwork, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child:
                artwork['imageUrl'] != null
                    ? Image.network(
                      artwork['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    )
                    : const Icon(Icons.image, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork['title']?.toString() ?? 'Untitled',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${(artwork['price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
