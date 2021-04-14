
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:floor/floor.dart';

@dao
abstract class SeriesCategoryHistoryDao {
  //select
  @Query('Select * from SeriesCategoryHistory')
  Future<List<SeriesCategoryHistory>> getAllSeriesCategoryHistory();

  @Query('Select * from SeriesCategoryHistory')
  Stream<List<SeriesCategoryHistory>> getAllSeriesCategoryHistoryByStream();

  @Query('Select * from SeriesCategoryHistory where id = :id')
  Future<SeriesCategoryHistory?> getSeriesCategoryHistoryById(int id);

  @Query('Select * from SeriesCategoryHistory where seriesId = :seriesId')
  Future<List<SeriesCategoryHistory>?> getCategoryFromSeriesId(int seriesId);

  @Query('Select * from SeriesCategoryHistory where categoryId = :categoryId')
  Future<List<SeriesCategoryHistory>?> getSeriesFromCategoryId(int categoryId);

  //insert
  @insert
  Future<int> insertCategorySeries(SeriesCategoryHistory seriesCategoryHistory);

  //delete
  @Query('Delete from SeriesCategoryHistory where id = :id')
  Future<void> deleteSeriesCategoryHistoryById(int id);

  @Query('Delete from SeriesCategoryHistory where seriesId = :id')
  Future<void> deleteSeriesCategoryHistoryFromSeriesId(int id);

  @Query('Delete from SeriesCategoryHistory')
  Future<void> deleteSeriesCategoryHistory();
}