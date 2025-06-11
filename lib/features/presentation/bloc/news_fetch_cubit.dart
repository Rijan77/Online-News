import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/response_enum.dart';
import 'package:news_app/features/data/api/static_api.dart';
import 'package:news_app/features/presentation/bloc/news_fetch_state.dart';


class NewsFetchCubit extends Cubit<NewsFetchState>{
  final NewsApi newsApi;
  NewsFetchCubit(this.newsApi) : super(NewsFetchState());



  Future<void> newsFetch () async{
    emit(state.copyWith(newsFetchStatus: ResponseEnum.loading));

    try {
      final newsModel = await newsApi.getNews();
      emit(state.copyWith(newsFetchStatus: ResponseEnum.success, newsModel: newsModel));
    } catch (e) {
      emit((state.copyWith(newsFetchStatus: ResponseEnum.failure)));
    }
  }


  Future<void> toggleFavorite(String articleId) async{
      if(!state.articleId.contains(articleId)){
        emit(state.copyWith(articleId: [articleId,...state.articleId]));
      }else{
        emit(state.copyWith(articleId: state.articleId.where((e)=> e != articleId).toList()));
      }



  }




}
