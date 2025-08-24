import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Kullanıcı ID al
  String get userId => _auth.currentUser!.uid;

  // Favoriye ekle
  Future<void> addFavorite(String tripId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(tripId)
        .set({'createdAt': FieldValue.serverTimestamp()});
  }

  // Favoriden çıkar
  Future<void> removeFavorite(String tripId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(tripId)
        .delete();
  }

  // Favori mi?
  Future<bool> isFavorite(String tripId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(tripId)
        .get();

    return doc.exists;
  }

  // Tüm favorileri getir
  Future<List<String>> getFavorites() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
