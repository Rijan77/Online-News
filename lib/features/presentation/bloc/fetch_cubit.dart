

import 'package:flutter_bloc/flutter_bloc.dart';

import 'fetch_state.dart';


class FetchNewsCubit extends Cubit<FetchNews> {
  FetchNewsCubit(): super(InitialFetchNews());

  Future<void> fetchNews() async{
    emit(LoadingFetchNews());
  }


}
