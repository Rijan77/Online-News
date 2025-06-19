import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

import '../../../../core/helpers/database_helper.dart';
import '../../../../core/utils/response_enum.dart';
import '../../data/models/news_model_api.dart';
import '../../data/repositories/static_api.dart';
import 'news_fetch_state.dart';


class NewsFetchCubit extends Cubit<NewsFetchState> {
  final NewsApi newsApi;
  final DatabaseHelper databaseHelper;

  NewsFetchCubit({
    required this.newsApi,
    required this.databaseHelper,
  }) : super(const NewsFetchState());

  Future<void> newsFetch() async {
    emit(state.copyWith(newsFetchStatus: ResponseEnum.loading));
    try {
      final newsModel = await newsApi.getNews();
      emit(state.copyWith(
        newsFetchStatus: ResponseEnum.success,
        newsModel: newsModel,
      ));
      await _loadFavorites();
    } catch (e) {
      emit(state.copyWith(
        newsFetchStatus: ResponseEnum.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _loadFavorites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email == null) return;

    emit(state.copyWith(favoriteFetchStatus: ResponseEnum.loading));
    try {
      final favorites = await databaseHelper.getFavorites();
      final favoriteIds = favorites
          .map((f) => f.articleId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      emit(state.copyWith(
        favoriteFetchStatus: ResponseEnum.success,
        articleId: favoriteIds,
      )
      );

    } catch (e) {
      emit(state.copyWith(
        favoriteFetchStatus: ResponseEnum.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> toggleFavorite(NewsData news, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    emit(state.copyWith(favoriteFetchStatus: ResponseEnum.loading));
    try {
      final currentFavorites = List<String>.from(state.articleIds);
      final isFavorite = currentFavorites.contains(news.articleId);

      if (isFavorite) {
        await databaseHelper.deleteFavorite(
            news.articleId, currentUser.email!);
        currentFavorites.remove(news.articleId);
      } else {
        await databaseHelper.insertFavorite(news, currentUser.email!);
        currentFavorites.add(news.articleId);
            }

      emit(state.copyWith(
        favoriteFetchStatus: ResponseEnum.success,
        articleId: currentFavorites,
      ));
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: isFavorite ? "Remove from favorites" : "Added to favorites",
          backgroundColor: isFavorite ? Colors.redAccent : Colors.blueGrey,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        favoriteFetchStatus: ResponseEnum.failure,
        error: "Failed to update favorites",
      ));
    }
  }

  Future<void> refreshData() async {
    final url = Uri.parse("http://10.13.172.119:8080/newsapi-web/webresources/newsdata/refresh");

    await http.get(url);
    await newsFetch();
    await _loadFavorites();
  }
}