import 'package:floor/floor.dart';

@Entity(tableName: 'Series')
class Series {
  @PrimaryKey(autoGenerate: true)
  final int? seriesId;
  final String name;
  final String url;
  final String? photoUrl;
  int season;
  int episode;
  int movie;

  Series({this.seriesId, required this.name, required this.url, this.photoUrl, this.season = 0, this.episode = 0, this.movie = 0});

  void setInitWatching({int season = 0, int episode = 0, int movie = 0}) {
    this.season = season;
    this.episode = episode;
    this.movie = movie;
  }

  Map<String, dynamic> toMap() {
    return {
      'seriesId': seriesId,
      'name': name,
      'url': url,
      'photoUrl': photoUrl,
      'season': season,
      'episode': episode,
      'movie': movie
    };
  }

  Series.fromMapToObject(Map<String, dynamic> data)
      :seriesId = data['seriesId'],
        name = data['name'],
        url = data['url'],
        photoUrl = data['photoUrl'],
        season = data['season'],
        episode = data['episode'],
        movie = data['movie'];
}