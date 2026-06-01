class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
  });

  factory NewsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return NewsModel(
      title: map['title'] ?? '',
      description:
          map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl:
          map['urlToImage'] ?? '',
      source:
          map['source']?['name'] ?? '',
    );
  }
}