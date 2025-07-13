class DioModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  DioModel(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory DioModel.fromJson(Map<String, dynamic> json) {
    return DioModel(
        userId: json["userId"],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}
