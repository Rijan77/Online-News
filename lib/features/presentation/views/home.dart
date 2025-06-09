import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../database/database_helper.dart';
import '../../data/api/model_api.dart';
import '../bloc/fetch_cubit.dart';
import '../bloc/fetch_state.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'favorites_page.dart';

Future<void> toggleFavorite(NewsData news, bool isCurrentlyFavorite, BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser?.email == null) return;

  try {
    if (isCurrentlyFavorite) {
      // Remove from favorites
      await DatabaseHelper.instance.deleteFavorite(news.articleId!, currentUser!.email!);
    } else {
      // Add to favorites
      if (news.articleId != null) {
        await DatabaseHelper.instance.insertFavorite(news, currentUser!.email!);
      }
    }
  } catch (e) {
    log("Error toggling favorite: $e");
    rethrow;
  }
}



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ValueNotifier<bool>> favoriteStatusList = [];
  User? _currentUser;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  FavoritesPage favoritesPage = new FavoritesPage();


  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<FetchNewsCubit>();
      cubit.fetchNews();
    });
  }

  @override
  void dispose() {
    for (var notifier in favoriteStatusList) {
      notifier.dispose();
    }
    super.dispose();
  }

  Future<void> _checkFavoriteStatuses(List<NewsData> news) async {
    if (_currentUser?.email == null) return;

    for (int i = 0; i < news.length; i++) {
      final articleId = news[i].articleId;
      if (articleId != null) {
        final isFavorite = await DatabaseHelper.instance.isFavorite(
            articleId, _currentUser!.email!);
        if (i < favoriteStatusList.length) {
          favoriteStatusList[i].value = isFavorite;
        }
      }
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<
      RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade200,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, size: 30),
        ),
        title: const Center(
          child: Text(
            "Online News",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/fourth');
              },
              icon: const Icon(Icons.favorite, size: 35),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FetchNewsCubit, FetchNews>(
        builder: (context, state) {
          if (state is InitialFetchNews || state is LoadingFetchNews) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (state is ErrorFetchNews) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is SuccessFetchNews) {
            final news = state.newModel;

            // Initialize favorite status list
            if (favoriteStatusList.length != news.length) {
              favoriteStatusList.clear();
              favoriteStatusList.addAll(
                List.generate(news.length, (_) => ValueNotifier<bool>(false)),
              );
              _checkFavoriteStatuses(news);
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.white,
              backgroundColor: Colors.blueGrey,
              strokeWidth: 3.0,
              onRefresh: () async {
                await context.read<FetchNewsCubit>().fetchNews();
              },
              child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = news[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: item.imageUrl != null
                              ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.25,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: screenHeight * 0.25,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                      Icons.broken_image, size: 50),
                                ),
                          )
                              : Container(
                            height: screenHeight * 0.25,
                            color: Colors.grey[200],
                            child: const Center(
                                child: Text("No Image Available")),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? "No title available",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    item.pubDate != null
                                        ? timeago.format(
                                        DateTime.parse(item.pubDate!),
                                        allowFromNow: true)
                                        : "Date not available",
                                    style: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 15),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: favoriteStatusList[index],
                                    builder: (context, isFavorite, _) {
                                      return IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons
                                              .favorite_border,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await toggleFavorite(
                                                item, isFavorite, context);
                                            if (
                                            favoriteStatusList[index].value =
                                            !isFavorite) {
                                              showTopSnackBar(
                                                Overlay.of(context),
                                                CustomSnackBar.info(
                                                  message: "Added to favorites",
                                                  backgroundColor: isFavorite
                                                      ? Colors.redAccent
                                                      : Colors.blueGrey,
                                                ),
                                              );
                                            } else {


                                            }
                                          } catch (e) {
                                            showTopSnackBar(
                                              Overlay.of(context),
                                              const CustomSnackBar.error(
                                                message: "Failed to update favorites",
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}
