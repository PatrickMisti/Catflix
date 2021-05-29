import 'package:floor/floor.dart';

@Entity(tableName: 'Series')
class Series {
  @PrimaryKey(autoGenerate: true)
  final int? seriesId;
  final String name;
  final String url;
  final String? photoUrl;
  String currentSeriesName = "";
  String currentSeriesUrl = "";

  Series({this.seriesId, required this.name, required this.url, this.photoUrl, this.currentSeriesName = "", this.currentSeriesUrl = ""});

  void setInitWatching({required String currentName, required String currentUrl}) {
    this.currentSeriesUrl = currentUrl;
    this.currentSeriesName = currentName;
  }

  Map<String, dynamic> toMap() {
    return {
      'seriesId': seriesId,
      'name': name,
      'url': url,
      'photoUrl': photoUrl,
      'currentSeriesName': currentSeriesName,
      'currentSeriesUrl': currentSeriesUrl
    };
  }

  Series.fromMapToObject(Map<String, dynamic> data)
      :seriesId = data['seriesId'],
        name = data['name'],
        url = data['url'],
        photoUrl = data['photoUrl'],
        currentSeriesUrl = data['currentSeriesUrl'],
        currentSeriesName = data['currentSeriesName'];
}