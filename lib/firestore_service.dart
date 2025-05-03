import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getArtworks() {
    return _db
        .collection('artworks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> searchArtworks(String query) async {
    return await _db
        .collection('artworks')
        .where('searchKeywords', arrayContains: query.toLowerCase())
        .get();
  }

  Future<void> addArtwork({
    required String title,
    required String imageUrl,
    required double price,
    required String description,
  }) async {
    await _db.collection('artworks').add({
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
      'searchKeywords': _generateKeywords(title + ' ' + description),
    });
  }

  List<String> _generateKeywords(String text) {
    final words = text.toLowerCase().split(' ');
    final keywords = <String>[];
    for (var i = 0; i < words.length; i++) {
      for (var j = 1; j <= words.length - i; j++) {
        keywords.add(words.sublist(i, i + j).join(' '));
      }
    }
    return keywords;
  }
}
