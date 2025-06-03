class Model {
  String? status;
  int? totalResults;
  List<Results>? results;
  String? nextPage;

  Model({this.status, this.totalResults, this.results, this.nextPage});

  Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['nextPage'] = nextPage;
    return data;
  }
}

class Results {
  String? articleId;
  String? title;
  String? link;
  List<String>? keywords;
  List<String>? creator;
  String? description;
  String? content;
  String? pubDate;
  String? pubDateTZ;
  String? imageUrl;
  Null videoUrl;
  String? sourceId;
  String? sourceName;
  int? sourcePriority;
  String? sourceUrl;
  String? sourceIcon;
  String? language;
  List<String>? country;
  List<String>? category;
  String? sentiment;
  String? sentimentStats;
  String? aiTag;
  String? aiRegion;
  String? aiOrg;
  bool? duplicate;

  Results(
      {this.articleId,
        this.title,
        this.link,
        this.keywords,
        this.creator,
        this.description,
        this.content,
        this.pubDate,
        this.pubDateTZ,
        this.imageUrl,
        this.videoUrl,
        this.sourceId,
        this.sourceName,
        this.sourcePriority,
        this.sourceUrl,
        this.sourceIcon,
        this.language,
        this.country,
        this.category,
        this.sentiment,
        this.sentimentStats,
        this.aiTag,
        this.aiRegion,
        this.aiOrg,
        this.duplicate});

  Results.fromJson(Map<String, dynamic> json) {
    articleId = json['article_id'];
    title = json['title'];
    link = json['link'];
    keywords = json['keywords'].cast<String>();
    creator = json['creator'].cast<String>();
    description = json['description'];
    content = json['content'];
    pubDate = json['pubDate'];
    pubDateTZ = json['pubDateTZ'];
    imageUrl = json['image_url'];
    videoUrl = json['video_url'];
    sourceId = json['source_id'];
    sourceName = json['source_name'];
    sourcePriority = json['source_priority'];
    sourceUrl = json['source_url'];
    sourceIcon = json['source_icon'];
    language = json['language'];
    country = json['country'].cast<String>();
    category = json['category'].cast<String>();
    sentiment = json['sentiment'];
    sentimentStats = json['sentiment_stats'];
    aiTag = json['ai_tag'];
    aiRegion = json['ai_region'];
    aiOrg = json['ai_org'];
    duplicate = json['duplicate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['article_id'] = articleId;
    data['title'] = title;
    data['link'] = link;
    data['keywords'] = keywords;
    data['creator'] = creator;
    data['description'] = description;
    data['content'] = content;
    data['pubDate'] = pubDate;
    data['pubDateTZ'] = pubDateTZ;
    data['image_url'] = imageUrl;
    data['video_url'] = videoUrl;
    data['source_id'] = sourceId;
    data['source_name'] = sourceName;
    data['source_priority'] = sourcePriority;
    data['source_url'] = sourceUrl;
    data['source_icon'] = sourceIcon;
    data['language'] = language;
    data['country'] = country;
    data['category'] = category;
    data['sentiment'] = sentiment;
    data['sentiment_stats'] = sentimentStats;
    data['ai_tag'] = aiTag;
    data['ai_region'] = aiRegion;
    data['ai_org'] = aiOrg;
    data['duplicate'] = duplicate;
    return data;
  }
}
