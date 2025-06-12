class NewsModel {
  final String? status;
  final int? totalResults;
  final List<NewsData> results;
  final String? nextPage;

  NewsModel({
    this.status,
    this.totalResults,
    required this.results,
    this.nextPage,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      results: (json['results'] as List)
          .map((item) => NewsData.fromJson(item))
          .toList(),
      nextPage: json['nextPage'],
    );
  }
}

class NewsData {
  final String? articleId;
  final String? title;
  final String? link;
  final List<String>? keywords;
  final List<String>? creator;
  final String? description;
  final String? content;
  final String? pubDate;
  final String? imageUrl;
  final String? sourceName;

  NewsData({
    this.articleId,
    this.title,
    this.link,
    this.keywords,
    this.creator,
    this.description,
    this.content,
    this.pubDate,
    this.imageUrl,
    this.sourceName,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      articleId: json['article_id'],
      title: json['title'],
      link: json['link'],
      keywords:
          json['keywords'] != null ? List<String>.from(json['keywords']) : null,
      creator:
          json['creator'] != null ? List<String>.from(json['creator']) : null,
      description: json['description'],
      content: json['content'],
      pubDate: json['pubDate'],
      imageUrl: json['image_url'],
      sourceName: json['source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': articleId,
      'title': title,
      'link': link,
      'keywords': keywords,
      'creator': creator,
      'description': description,
      'content': content,
      'pubDate': pubDate,
      'image_url': imageUrl,
      'source_name': sourceName,
    };
  }
}
