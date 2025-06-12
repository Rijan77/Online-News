
import 'package:flutter/material.dart';
import 'package:news_app/features/data/api/model_api.dart';
import 'package:path/path.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../bloc/fetch_cubit.dart';




Widget buildLandscapeGridView(List<NewsData> news, FetchNewsCubit cubit, double screenHeight,  BuildContext context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  return  RefreshIndicator(
      onRefresh: () async {
    await cubit.fetchNews();
    await cubit.updateFavoriteCount();
  },
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isPortrait? 1: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      childAspectRatio: 1.2,
    ),
    padding: const EdgeInsets.all(20),
    itemCount: news.length,
    itemBuilder: (context, index) {
      final item = news[index];
      final isFavorite = cubit.favoriteArticleIds.contains(item.articleId);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: item.imageUrl != null
                    ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Container(
                          color: Colors.grey[200],
                          child: const Icon(
                              Icons.image_aspect_ratio_outlined,
                              color: Colors.black45,
                              size: 30),
                        ),
                      );
                    })
                    : Container(
                  color: Colors.grey[200],
                  child: const Center(child: Text("No Image Available")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "No title available",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.pubDate != null
                              ? timeago.format(
                              DateTime.parse(item.pubDate!),
                              allowFromNow: true)
                              : "Date not available",
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => cubit.toggleFavorite(item, context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  )
  );
}
