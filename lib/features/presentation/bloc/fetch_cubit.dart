import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/static_api.dart';
import 'fetch_state.dart';

class FetchNewsCubit extends Cubit<FetchNews> {
  final NewsApi newsApi;

  FetchNewsCubit(this.newsApi) : super(InitialFetchNews());

  Future<void> fetchNews() async {
    emit(LoadingFetchNews());
    try {
      final newsModel = await newsApi.getNews();
      emit(SuccessFetchNews(newsModel.results));
    } catch (e) {
      emit(ErrorFetchNews(e.toString()));
    }
  }
}