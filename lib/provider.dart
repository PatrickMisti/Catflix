import 'package:catflix/database/db/catflix_database.dart';
import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:flutter/widgets.dart';
import 'package:catflix/utilities/http-convert-sql.dart';

class Provider extends InheritedWidget {
  final CatflixDatabase db;
  final TargetPlatform osX;

  Provider({required this.db, required this.osX,required Widget child}) : super(child: child);

  static Provider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!;
  }

  @override
  bool updateShouldNotify(covariant Provider old) => db != old.db;


  Stream<List<Category>> get getCategoryStream => db.categoryDb.getAllCategoryByStream().asBroadcastStream();

  Stream<List<Series>> getSeriesFromCategoryStream(int id) => db.seriesDb.getAllSeriesFromCategoryIdByStream(id).asBroadcastStream();

  Future<Map<bool, String>> setSeriesUrl(String url) async => await db.saveDataIntoDb(url);

  Future<List<Series>> findSeriesByName(String name) async => (await db.seriesDb.findSeriesByName("%$name%"))!;

  Future<void> deleteSeriesById(int id) async {
    List<SeriesCategoryHistory> result = (await db.seriesCategoryHistoryDb.getCategoryFromSeriesId(id))!;
    await db.seriesCategoryHistoryDb.deleteSeriesCategoryHistoryFromSeriesId(id);
    await db.seriesDb.deleteSeries(id);

    for (SeriesCategoryHistory item in result) {
      List<SeriesCategoryHistory>? categoryList = await db.seriesCategoryHistoryDb.getSeriesFromCategoryId(item.categoryId);
      if (categoryList!.isEmpty)
        await db.categoryDb.deleteCategory(item.categoryId);
    }
  }
}
