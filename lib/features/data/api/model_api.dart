class NewsModel {
  NewsModel({
    required this.status,
    required this.totalResults,
    required this.results,
    required this.nextPage,
  });
  late final String status;
  late final int totalResults;
  late final List<NewsData> results;
  late final String nextPage;

  NewsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    totalResults = json['totalResults'];
    results = List.from(json['results']).map((e)=>NewsData.fromJson(e)).toList();
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    data['results'] = results.map((e)=>e.toJson()).toList();
    data['nextPage'] = nextPage;
    return data;
  }
}

class NewsData {
  NewsData({
    required this.articleId,
    required this.title,
    // this.link,
    // required this.keywords,
    // required this.creator,
    // required this.description,
    // required this.content,
    required this.pubDate,
    // required this.pubDateTZ,
    required this.imageUrl,
    // this.videoUrl,
    // required this.sourceId,
    // required this.sourceName,
    // required this.sourcePriority,
    // required this.sourceUrl,
    // required this.sourceIcon,
    // required this.language,
    // required this.country,
    // required this.category,
    // required this.sentiment,
    // required this.sentimentStats,
    // required this.aiTag,
    // required this.aiRegion,
    // required this.aiOrg,
    // required this.duplicate,
  });
  late final String articleId;
  late final String title;
  // late final String? link;
  // late final List<Keywords> keywords;
  // late final List<Creator> creator;
  // late final String description;
  // late final String? content;
  late final String pubDate;
  // late final String pubDateTZ;
  late final String imageUrl;
  // late final Null videoUrl;
  // late final String? sourceId;
  // late final String sourceName;
  // late final int sourcePriority;
  // late final String sourceUrl;
  // late final String sourceIcon;
  // late final String language;
  // late final List<Country> country;
  // late final List<Category> category;
  // late final String sentiment;
  // late final String sentimentStats;
  // late final String aiTag;
  // late final String aiRegion;
  // late final String aiOrg;
  // late final bool duplicate;

  NewsData.fromJson(Map<String, dynamic> json){
    articleId = json['article_id'];
    title = json['title'];
    // link = json['link'];
    // keywords = List.from(json['keywords']).map((e)=>Keywords.fromJson(e)).toList();
    // creator = List.from(json['creator']).map((e)=>Creator.fromJson(e)).toList();
    // description = json['description'];
    // content = json['content'];
    pubDate = json['pubDate'];
    // pubDateTZ = json['pubDateTZ'];
    imageUrl = json['image_url'];
    // videoUrl = null;
    // sourceId = json['source_id'];
    // sourceName = json['source_name'];
    // sourcePriority = json['source_priority'];
    // sourceUrl = json['source_url'];
    // sourceIcon = json['source_icon'];
    // language = json['language'];
    // country = List.from(json['country']).map((e)=>Country.fromJson(e)).toList();
    // category = List.from(json['category']).map((e)=>Category.fromJson(e)).toList();
    // sentiment = json['sentiment'];
    // sentimentStats = json['sentiment_stats'];
    // aiTag = json['ai_tag'];
    // aiRegion = json['ai_region'];
    // aiOrg = json['ai_org'];
    // duplicate = json['duplicate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['article_id'] = articleId;
    data['title'] = title;
    // _data['link'] = link;
    // _data['keywords'] = keywords.map((e)=>e.toJson()).toList();
    // _data['creator'] = creator.map((e)=>e.toJson()).toList();
    // _data['description'] = description;
    // _data['content'] = content;
    data['pubDate'] = pubDate;
    // _data['pubDateTZ'] = pubDateTZ;
    data['image_url'] = imageUrl;
    // _data['video_url'] = videoUrl;
    // _data['source_id'] = sourceId;
    // _data['source_name'] = sourceName;
    // _data['source_priority'] = sourcePriority;
    // _data['source_url'] = sourceUrl;
    // _data['source_icon'] = sourceIcon;
    // _data['language'] = language;
    // _data['country'] = country.map((e)=>e.toJson()).toList();
    // _data['category'] = category.map((e)=>e.toJson()).toList();
    // _data['sentiment'] = sentiment;
    // _data['sentiment_stats'] = sentimentStats;
    // _data['ai_tag'] = aiTag;
    // _data['ai_region'] = aiRegion;
    // _data['ai_org'] = aiOrg;
    // _data['duplicate'] = duplicate;
    return data;
  }
}

class Keywords {
  Keywords({
    required this.id,
    required this.keyword,
  });
  late final int id;
  late final String keyword;

  Keywords.fromJson(Map<String, dynamic> json){
    id = json['id'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['keyword'] = keyword;
    return data;
  }
}

class Creator {
  Creator({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Creator.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Country {
  Country({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Country.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}