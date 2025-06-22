import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> uploadNote({
  required String title,
  required String description,
  required File imageFile,
  required time,
  required creator
}) async {

  String apiUrl = " http://10.13.172.119:8080/newsapi-web/webresources/newsdata/getNotes";
  final  request = http.MultipartRequest('Post', Uri.parse(apiUrl));

  request.fields['title'] = title;
  request.fields['description'] =description;
  request.fields['time'] = time;
  request.fields['creator'] = creator;

  // request.files.add(http.MultipartFile.fromBytes(‘picture’, File(file!.path).readAsBytesSync(),filename: file!.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    print('Note uploaded successfully');
  } else {
    print('Failed to upload note. Status code: ${response.statusCode}');
  }
}

