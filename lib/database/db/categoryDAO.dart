import 'package:catflix/database/entities/category.dart';
import 'package:floor/floor.dart';

@dao
abstract class CategoryDao {
  //select
  @Query('Select * from Category')
  Future<List<Category>> getAllCategory();

  @Query('Select * from Category')
  Stream<List<Category>> getAllCategoryByStream();

  @Query('Select * from Category where name IN (:names)')
  Future<List<Category>?> getCategoriesFromListCategory(List<String> names);

  //insert
  @insert
  Future<int> insertCategory(Category category);

  @insert
  Future<List<int>> insertCategories(List<Category> categories);

  //delete
  @Query('Delete from Category where categoryId = :id')
  Future<void> deleteCategory(int id);

  @Query('Delete from Category')
  Future<void> deleteAllCategories();
}