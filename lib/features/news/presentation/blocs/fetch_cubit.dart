import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/data/models/news_model_api.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/helpers/database_helper.dart';
import '../../data/repositories/static_api.dart';
import 'fetch_state.dart';

class FetchNewsCubit extends Cubit<FetchNews> {
  final NewsApi newsApi;

  List<String> favoriteArticleIds = [];
  int favoriteCount = 0;

  FetchNewsCubit(this.newsApi) : super(InitialFetchNews()) {
    fetchNews();
  }

  Future<void> fetchNews() async {
    emit(LoadingFetchNews());
    try {
      final newsModel = await newsApi.getNews();
      emit(SuccessFetchNews(newsModel.results));
    } catch (e) {
      emit(ErrorFetchNews(e.toString()));
    }
  }

  Future<void> _loadFavorites() async {
    final currentUser = FirebaseAuth
        .instance.currentUser; //For getting currently login firebase user.
    if (currentUser?.email == null) return; //If user is not login return null.

    final favorites = await DatabaseHelper.instance
        .getFavorites(); //get the list of Favorites News from the database and store in favorite variable
    favoriteArticleIds = favorites
        .map((f) => f.articleId ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
  }

  Future<void> updateFavoriteCount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      favoriteCount =
          await DatabaseHelper.instance.countFavorites(currentUser!.email!);
      emit(SuccessFetchNews((state as SuccessFetchNews).newModel));
    } else {
      favoriteCount = 0;
    }
  }

  Future<void> toggleFavorite(NewsData news, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    try {
      final isFavorite = favoriteArticleIds.contains(news.articleId);
      if (isFavorite) {
        await DatabaseHelper.instance
            .deleteFavorite(news.articleId, currentUser.email!);
        favoriteArticleIds.remove(news.articleId);
      } else {
        await DatabaseHelper.instance
            .insertFavorite(news, currentUser.email!);
        favoriteArticleIds.add(news.articleId);
            }

      // Update the count after toggling
      await updateFavoriteCount();

      if (state is SuccessFetchNews) {
        emit(SuccessFetchNews((state as SuccessFetchNews).newModel));
      }
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: isFavorite ? "Remove from favorites" : "Added to favorites",
          backgroundColor: isFavorite ? Colors.redAccent : Colors.blueGrey,
        ),
      );
    } catch (e) {
      showTopSnackBar(Overlay.of(context),
          CustomSnackBar.error(message: "Failed to update favorites"));
    }
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
    await updateFavoriteCount();
    if (state is SuccessFetchNews) {
      emit(SuccessFetchNews((state as SuccessFetchNews).newModel));
    }
  }

// }
}
