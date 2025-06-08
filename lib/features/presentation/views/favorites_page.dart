import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/api/model_api.dart';
import 'package:timeago/timeago.dart' as timeago;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Favorites News")),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(child: Text('No favorites yet'));
      //     }
      //
      //     final favorites = snapshot.data!.docs.map((doc) {
      //       return NewsData.fromJson(doc.data() as Map<String, dynamic>);
      //     }).toList();
      //
      //     return ListView.builder(
      //       itemCount: favorites.length,
      //       itemBuilder: (context, index) {
      //         final news = favorites[index];
      //         return ListTile(
      //           leading: news.imageUrl != null
      //               ? Image.network(news.imageUrl!,
      //                   width: 60, height: 60, fit: BoxFit.cover)
      //               : const Icon(Icons.article),
      //           title: Text(news.title ?? 'No Title'),
      //           subtitle: Text(
      //             news.pubDate != null
      //                 ? timeago.format(DateTime.parse(news.pubDate!))
      //                 : "Date not available",
      //           ),
      //           trailing: IconButton(
      //             icon: const Icon(Icons.favorite, color: Colors.red),
      //             onPressed: () async {
      //               try {
      //                 await FirebaseFirestore.instance
      //                     .collection('favorites')
      //                     .doc(news.articleId)
      //                     .delete();
      //               } catch (e) {
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   SnackBar(
      //                       content: Text('Failed to remove favorite: $e')),
      //                 );
      //               }
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
