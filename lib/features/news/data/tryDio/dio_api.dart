import 'package:dio/dio.dart';
import 'package:news_app/features/news/data/tryDio/dio_model.dart';

class DioApi {
  final Dio dio = Dio();

  Future<List<DioModel>> fetchData() async {
    try {
      final response =
          await dio.get("https://jsonplaceholder.typicode.com/posts");

      List<DioModel> mapModel = (response.data as List).map((json)=> DioModel.fromJson(json)).toList();

      return mapModel;

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
