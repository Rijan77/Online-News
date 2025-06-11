
import '../../data/api/model_api.dart';

abstract class FetchNews {}

class InitialFetchNews extends FetchNews {}

class LoadingFetchNews extends FetchNews {}

class SuccessFetchNews extends FetchNews {
  final List<NewsData> newModel;
  SuccessFetchNews(this.newModel);
}

class ErrorFetchNews extends FetchNews {
  final String message;
  ErrorFetchNews(this.message);
}

class LoadData extends FetchNews{
  final List<int> articalId;

  LoadData(this.articalId);
}