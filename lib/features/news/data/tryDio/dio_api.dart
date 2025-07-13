import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/features/news/data/tryDio/dio_model.dart';

class DioApi {
  final Dio dio = Dio();

  DioApi() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      print("Send request  to: ${options.uri}");

      options.headers["Authorization"] = "Bearer dummy_token";
      return handler.next(options);
    }, onResponse: (response, handler) {
      print("Response Recived: ${response.statusCode}");
      return handler.next(response);
    }, onError: (error, handler) {
      print("Error: ${error.message}");
      return handler.next(error);
    }));
  }

  Future<List<DioModel>> fetchData() async {
    try {
      final response =
          await dio.get("https://jsonplaceholder.typicode.com/posts");

      List<DioModel> mapModel = (response.data as List)
          .map((json) => DioModel.fromJson(json))
          .toList();

      return mapModel;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
