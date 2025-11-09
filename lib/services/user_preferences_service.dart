import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final List<String> areas;
  final List<String> markets;
  final List<String> categories;
  const UserPreferences({this.areas = const [], this.markets = const [], this.categories = const []});
}

class UserPreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserPreferences> fetch(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).collection('meta').doc('preferences').get();
    if (!doc.exists) return const UserPreferences();
    final data = doc.data() ?? {};
    return UserPreferences(
      areas: List<String>.from(data['areas'] ?? const []),
      markets: List<String>.from(data['markets'] ?? const []),
      categories: List<String>.from(data['categories'] ?? const []),
    );
  }

  Future<void> save(String userId, UserPreferences prefs) async {
    await _firestore.collection('users').doc(userId).collection('meta').doc('preferences').set({
      'areas': prefs.areas,
      'markets': prefs.markets,
      'categories': prefs.categories,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}


