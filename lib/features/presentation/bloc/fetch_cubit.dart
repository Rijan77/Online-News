

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/data/api/static_api.dart';

import 'fetch_state.dart';


class FetchNewsCubit extends Cubit<FetchNews> {

  final ApiService _apiService;

  FetchNewsCubit(this._apiService): super(InitialFetchNews());

  Future<void> fetchNews() async{
    emit(LoadingFetchNews());

    final service = await _apiService.getAll();
    emit(SuccessFetchNews());
  }


}
