import 'package:catflix/database/entities/series.dart';
import 'package:floor/floor.dart';

@dao
abstract class SeriesDao {
  //select
  @Query('Select * from Series')
  Future<List<Series>> getAllSeries();

  @Query('Select * from Series')
  Stream<List<Series>> getAllSeriesByStream();

  @Query('Select s.* from SeriesCategoryHistory cs left outer join Series s on s.seriesId = cs.seriesId where cs.categoryId = :id')
  Stream<List<Series>> getAllSeriesFromCategoryIdByStream(int id);

  @Query('Select * from Series where url = :url')
  Future<List<Series>?> getSeriesFromUrlCompare(String video);

  @Query('Select * from Series where name Like :input')
  Future<List<Series>?> findSeriesByName(String input);

  @Query('Select * from Series where seriesId = :id')
  Future<Series?> findSeriesById(int id);

  //insert
  @insert
  Future<int> insertSeries(Series series);

  //update
  @Update(onConflict: OnConflictStrategy.fail)
  Future<void> updateSeries(Series series);

  //delete
  @Query('Delete from Series where seriesId = :id')
  Future<void> deleteSeries(int id);

  @Query('Delete from Series')
  Future<void> deleteAllSeries();
}