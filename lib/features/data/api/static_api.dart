import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String apiKey = "5c7a4aa3aa3fc784cdeb16f5e046313e";
  static String apiUrl = "http://api.aviationstack.com/v1/flights?access_key=$apiKey&search=NepalAirlines";

  static Future<List> fetchFlights() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      print("API Status Code: ${response.statusCode}");
      print("API Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Decoded JSON: $jsonData");

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          return (jsonData['data'] as List);
              // .map<Data>((item) => Data.fromJson(item))
              // .toList();
        } else {
          print("Unexpected JSON format: $jsonData");
        }
      } else {
        print("Failed to load flights: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }

    return [];
  }
}
