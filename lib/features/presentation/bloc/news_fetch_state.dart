import 'package:equatable/equatable.dart';
import 'package:news_app/core/utils/response_enum.dart';
import 'package:news_app/features/data/api/model_api.dart';

class NewsFetchState extends Equatable {
  final ResponseEnum newsFetchStatus;
  final ResponseEnum favoriteFetchStatus;
  final NewsModel? newsModel;
  final List<String> articleId;
  final String error;

  const NewsFetchState({
    this.newsFetchStatus = ResponseEnum.initial,
    this.favoriteFetchStatus = ResponseEnum.initial,
    this.newsModel,
    this.articleId = const [],
    this.error = '',
  });

  NewsFetchState copyWith({
    ResponseEnum? newsFetchStatus,
    ResponseEnum? favoriteFetchStatus,
    NewsModel? newsModel,
    List<String>? articleId,
    String? error,
  }) {
    return NewsFetchState(
      newsFetchStatus: newsFetchStatus ?? this.newsFetchStatus,
      favoriteFetchStatus: favoriteFetchStatus ?? this.favoriteFetchStatus,
      newsModel: newsModel ?? this.newsModel,
      articleId: articleId ?? this.articleId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    newsFetchStatus,
    favoriteFetchStatus,
    newsModel,
    articleId,
    error,
  ];
}