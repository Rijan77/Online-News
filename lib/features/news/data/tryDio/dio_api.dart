import 'package:dio/dio.dart';
import 'package:news_app/features/news/data/tryDio/auth_token_storage.dart';
import 'package:news_app/features/news/data/tryDio/dio_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioApi {
  final Dio dio = Dio();

  DioApi() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final token = AuthTokenStorage.getToken();

      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
        print("Token attached: $token");
      } else {
        print("No Token Found!");
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      print("Response Recived: ${response.statusCode}");
      return handler.next(response);
    }, onError: (DioException error, handler) {
      if (error.response?.statusCode == 401) {
        print("Unauthorized! Token Might be expired.");
      }
      return handler.next(error);
    }),

    );

    dio.interceptors.add(
        PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 120
        )
    )  ;
  }

  Future<Response> get(String path) async => await dio.get(path);

  Future <Response> post(String path, {Map<String, dynamic>? data}) async =>
      await dio.post(path, data: data);



  Future<List<DioModel>> fetchData() async {
    print("⏳ Calling API...");
    try {
      final response =
          await dio.get("https://jsonplaceholder.typicode.com/posts");

      print("✅ Data fetched!");

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
