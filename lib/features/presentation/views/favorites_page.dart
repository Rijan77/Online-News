import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesRef = FirebaseFirestore.instance.collection('favorites');

    return Scaffold(

      appBar: AppBar(
          title: const Center(child: Text("Favorites News", style: TextStyle(fontWeight: FontWeight.w700),)),
        backgroundColor: Colors.blueGrey.shade200,
      ),

      // body: StreamBuilder<QuerySnapshot>(
      //   stream: favoritesRef.snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //
      //     final docs = snapshot.data!.docs;
      //     final List<NewsData> favorites = docs
      //         .map((doc) => NewsData.fromJson(doc.data()! as Map<String, dynamic>))
      //         .toList();
      //
      //     return ListView.builder(
      //       itemCount: favorites.length,
      //       itemBuilder: (context, index) {
      //         final news = favorites[index];
      //         return ListTile(
      //           leading: news.imageUrl != null
      //               ? Image.network(news.imageUrl!, width: 60)
      //               : null,
      //           title: Text(news.title ?? 'No Title'),
      //           subtitle: Text(news.pubDate ?? ''),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
