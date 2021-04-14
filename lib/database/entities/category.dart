import 'package:floor/floor.dart';

@Entity(tableName: 'Category')
class Category {
  @PrimaryKey(autoGenerate: true)
  final int? categoryId;
  final String name;

  Category({this.categoryId, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name
    };
  }

  Category.fromMapToObject(Map<String, dynamic> data)
      :categoryId = data['categoryId'], name = data['name'];
}