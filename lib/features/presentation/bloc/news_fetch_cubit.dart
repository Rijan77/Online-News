import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/response_enum.dart';
import 'package:news_app/features/data/api/static_api.dart';
import 'package:news_app/features/presentation/bloc/news_fetch_state.dart';

import '../../../database/database_helper.dart';
import '../../data/api/model_api.dart';

class NewsFetchCubit extends Cubit<NewsFetchState> {
  final NewsApi newsApi;

  NewsFetchCubit(this.newsApi) : super(NewsFetchState());

  Future<void> newsFetch() async {
    emit(state.copyWith(newsFetchStatus: ResponseEnum.loading));

    try {
      final newsModel = await newsApi.getNews();
      emit(state.copyWith(
          newsFetchStatus: ResponseEnum.success, newsModel: newsModel));
    } catch (e) {
      emit((state.copyWith(newsFetchStatus: ResponseEnum.failure)));
    }
  }

  Future<void> favoriteFetch() async {
    try {
      final favorite = await DatabaseHelper.instance.getFavorites();

      final favoriteIds = favorite
          .map((f) => f.articleId ?? ' ')
          .where((id) => id.isNotEmpty)
          .toList();

      emit(state.copyWith(
          favoriteFetchStatus: ResponseEnum.success, articleId: favoriteIds));
    } catch (e) {
      emit(state.copyWith(favoriteFetchStatus: ResponseEnum.failure));
    }

    // final currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser?.email == null) return;
    //
    // try {
    //   emit(state.copyWith(favoriteFetchStatus: ResponseEnum.loading));
    //
    //   final favorites = await DatabaseHelper.instance.getFavorites();
    //
    //   final favoriteIds = favorites
    //       .map((f) => f.articleId ?? '')
    //       .where((id) => id.isNotEmpty)
    //       .toList();
    //
    //   emit(state.copyWith(
    //     favoriteFetchStatus: ResponseEnum.success,
    //     articleId: favoriteIds,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(favoriteFetchStatus: ResponseEnum.failure));
    // }
  }

  Future<void> toggleFavorite(NewsData news, String articleId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    try {
      emit(state.copyWith(favoriteFetchStatus: ResponseEnum.loading));

      final currentFavorites = List<String>.from(state.articleId ?? []);

      if (currentFavorites.contains(articleId)) {
        // Remove from favorites
        await DatabaseHelper.instance
            .deleteFavorite(articleId, currentUser.email!);
        currentFavorites.remove(articleId);
      } else {
        // Add to favorites
        await DatabaseHelper.instance.insertFavorite(news, currentUser.email!);
        currentFavorites.add(articleId);
      }

      emit(state.copyWith(
        favoriteFetchStatus: ResponseEnum.success,
        articleId: currentFavorites,
      ));
    } catch (e) {
      emit(state.copyWith(favoriteFetchStatus: ResponseEnum.failure));
    }
  }

// if(!state.articleId.contains(articleId)){
//   emit(state.copyWith(articleId: [articleId,...state.articleId]));
// }else{
//   emit(state.copyWith(articleId: state.articleId.where((e)=> e != articleId).toList()));
// }
}
