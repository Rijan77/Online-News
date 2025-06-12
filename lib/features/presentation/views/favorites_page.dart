import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/database_helper.dart';
import '../../data/api/model_api.dart';
import '../bloc/fetch_cubit.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();


}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late Future<List<NewsData>> _favoritesFuture;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    loadFavorites();
  }

  void loadFavorites() {
    if (_currentUser?.email != null) {
      _favoritesFuture = _dbHelper.getFavorites();
    } else {
      _favoritesFuture = Future.value([]);
    }
    if (mounted) setState(() {});
  }

  Future<void> removeFavorite(NewsData item) async {
    if (_currentUser?.email == null) return;

    try {
      await _dbHelper.deleteFavorite(item.articleId!, _currentUser!.email!);
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            message: "Removed from favorites",
            backgroundColor: Colors.redAccent,
          ),
        );
        loadFavorites();

        // Update the favorite count in the home screen
        context.read<FetchNewsCubit>().updateFavoriteCount();
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            message: "Unable to Remove from favorites",
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isPortrait? kToolbarHeight : kToolbarHeight * 0.4,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child:  Icon(Icons.arrow_back,
              size: isPortrait? 35: 25
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: isPortrait? 45 : 230),
          child: const Text(
            "Favorites News",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    final isPortrait = MediaQuery.of(context).orientation==Orientation.portrait;
    if (_currentUser == null) {
      return const Center(child: Text('Please login to view favorites'));
    }

    return FutureBuilder<List<NewsData>>(
      future: _favoritesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load favorites'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loadFavorites,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        return RefreshIndicator(
          onRefresh: () {
            loadFavorites();
            return _favoritesFuture;
          },

          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait? 1:2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) =>
                _buildFavoriteItem(favorites[index]),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteItem(NewsData item) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation==Orientation.portrait;

    return
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
        margin:  EdgeInsets.symmetric(vertical: isPortrait? 1: 8, horizontal: 16),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: isPortrait? screenHeight * 0.222: screenHeight * 0.4,

                      // height: screenHeight * 0.2,
                      errorBuilder: (_, __, ___) =>
                          _buildPlaceholderImage(screenHeight),
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
                        fontSize: 18, fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                   SizedBox(height: isPortrait? 6: 12 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.pubDate != null
                              ? timeago.format(DateTime.parse(item.pubDate!),
                                  allowFromNow: true)
                              : "Date not available",
                          style:
                              const TextStyle(color: Colors.blueGrey, fontSize: 15),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_sharp, color: Colors.red, size: 20,),
                        onPressed: () => removeFavorite(item),
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
