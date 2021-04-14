import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:floor/floor.dart';


@Entity(tableName: 'SeriesCategoryHistory',
    foreignKeys: [
      ForeignKey(childColumns: ['categoryId'], parentColumns: ['categoryId'], entity: Category),
      ForeignKey(childColumns: ['seriesId'], parentColumns: ['seriesId'], entity: Series)
    ])
class SeriesCategoryHistory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int categoryId;
  final int seriesId;

  SeriesCategoryHistory({this.id, required this.categoryId, required this.seriesId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'seriesId': seriesId
    };
  }

  SeriesCategoryHistory.fromMapToObject(Map<String, dynamic> data)
      :id = data['id'],
        categoryId = data['categoryId'],
        seriesId = data['seriesId'];
}