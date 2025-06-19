import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/database_helper.dart';
import '../../../../core/helpers/datetime_helper.dart';
import '../../data/models/news_model_api.dart';
import '../blocs/news_fetch_cubit.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ValueNotifier<List<NewsData>> _favoritesNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      final favorites = await DatabaseHelper.instance.getFavorites();
      _favoritesNotifier.value = favorites;
    }
  }

  Future<void> _removeFavorite(NewsData item) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email == null) return;

    try {
      await DatabaseHelper.instance.deleteFavorite(
          item.articleId, currentUser!.email!);
      await _loadFavorites();
      context.read<NewsFetchCubit>().refreshData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove favorite: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isPortrait ? kToolbarHeight : kToolbarHeight * 0.4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: isPortrait ? 35 : 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: isPortrait ? 45 : 230),
          child: const Text("Favorites News"),
        ),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Please login to view favorites'));
    }

    return ValueListenableBuilder<List<NewsData>>(
      valueListenable: _favoritesNotifier,
      builder: (context, favorites, _) {
        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        return RefreshIndicator(
          onRefresh: _loadFavorites,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
              childAspectRatio: 1.2,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) => _buildFavoriteItem(favorites[index]),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteItem(NewsData item) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: isPortrait ? 1 : 8,
            horizontal: 16
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: item.imageUrl != null
                  ? Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: isPortrait ? screenHeight * 0.222 : screenHeight * 0.4,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(screenHeight),
              )
                  : _buildPlaceholderImage(screenHeight),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "No title available",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isPortrait ? 6 : 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.pubDate != null
                              ? DateTimeHelper.timeAgoSinceDate((item.pubDate),)
                              : "Date not available",
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_sharp,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => _removeFavorite(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(double height) {
    return Container(
      height: height * 0.25,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, size: 50)),
    );
  }
}