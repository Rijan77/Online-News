import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'model_api.dart';

class NewsApi {
  static const String _apiKey = "pub_eb489e3551f5456ca88d91408414c61c";
  static const String _baseUrl = "https://newsdata.io/api/1/latest";

  Future<NewsModel> getNews() async {
    // final url = Uri.parse("http://10.13.172.119:8081/news");

    final url = Uri.parse("$_baseUrl?apikey=$_apiKey&q=Hot%20news");
    log("Fetching news from: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log("API Response: ${jsonData.toString()}");

      try {
        final newsModel = NewsModel.fromJson(jsonData);
        log("Fetched ${newsModel.results.length} articles");
        return newsModel;
      } catch (e) {
        log("Error parsing news data: $e");
        throw "Failed to parse news data";
      }
    } else {
      log("API Error: ${response.statusCode} - ${response.body}");
      throw "Failed to load news: ${response.statusCode}";
    }
  }
}
