

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/static_api.dart';
import 'fetch_state.dart';


class FetchNewsCubit extends Cubit<FetchNews> {

  final NewsApi _newsApi;

  FetchNewsCubit(this._newsApi): super(InitialFetchNews());

  Future<void> fetchNews() async{
    emit(LoadingFetchNews());

    try{
      final newsService = await _newsApi.getAll();
      emit(SuccessFetchNews(newsService));
    }
    catch(e){
      emit(ErrorFetchNews(e.toString()));
    }


  }

}
