import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/api/model_api.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(NewsData news, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(news.articleId)
        .set(news.toJson());
  }

  Future<void> removeFromFavorites(String articleId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(articleId)
        .delete();
  }

  Stream<List<NewsData>> getFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NewsData.fromJson(doc.data()))
          .toList();
    });
  }
}
