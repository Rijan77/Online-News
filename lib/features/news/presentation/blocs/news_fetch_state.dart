import 'package:equatable/equatable.dart';

import '../../../../core/utils/response_enum.dart';
import '../../data/models/news_model_api.dart';



class NewsFetchState extends Equatable {
  final ResponseEnum newsFetchStatus;
  final ResponseEnum favoriteFetchStatus;
  final NewsModelApi? newsModel;
  final List<String> articleIds;
  final String error;

  const NewsFetchState({
    this.newsFetchStatus = ResponseEnum.initial,
    this.favoriteFetchStatus = ResponseEnum.initial,
    this.newsModel,
    this.articleIds = const [],
    this.error = '',
  });

  NewsFetchState copyWith({
    ResponseEnum? newsFetchStatus,
    ResponseEnum? favoriteFetchStatus,
    NewsModelApi? newsModel,
    List<String>? articleId,
    String? error,
  }) {
    return NewsFetchState(
      newsFetchStatus: newsFetchStatus ?? this.newsFetchStatus,
      favoriteFetchStatus: favoriteFetchStatus ?? this.favoriteFetchStatus,
      newsModel: newsModel ?? this.newsModel,
      articleIds: articleId ?? articleIds,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    newsFetchStatus,
    favoriteFetchStatus,
    newsModel,
    articleIds,
    error,
  ];
}