import 'dart:async';
import 'package:catflix/database/db/catflix_database.dart';
import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("entity", (){
    test("toMap correct", () {
      Category category = new Category(categoryId: 1, name: "Hallo");
      var categoryToMap = category.toMap();
      Category newCategory = new Category.fromMapToObject(categoryToMap);
      expect(newCategory.categoryId, category.categoryId,reason: "Category id is not same");
      expect(newCategory.name, category.name,reason: "Category name is not same");

      Series series = new Series(name: "Haikyuu", url: "https://series.sx/stream/haikyuu", photoUrl: "https://serienstream.sx/public/img/cover/the-walking-dead-stream-cover-bdLSu6osdy0vDHrGnsrKrxw9HIGgBr99_220x330.jpg");
      var seriesToMap = series.toMap();
      Series newSeries = new Series.fromMapToObject(seriesToMap);
      expect(newSeries.seriesId, series.seriesId,reason: "Series id is not same");
      expect(newSeries.name, series.name,reason: "Series name is not same");

      SeriesCategoryHistory scHistory = new SeriesCategoryHistory(id: 1,categoryId: 1, seriesId: 1);
      var scHistoryToMap = scHistory.toMap();
      SeriesCategoryHistory newScHistory = new SeriesCategoryHistory.fromMapToObject(scHistoryToMap);
      expect(newScHistory.id, scHistory.id,reason: "SCH id is not same");
      expect(newScHistory.seriesId, scHistory.seriesId,reason: "SCH seriesId is not same");
      expect(newScHistory.categoryId, scHistory.categoryId,reason: "SCH categoryId is not same");
      print("test toMap success");
    });

    test("database test Series", () async {
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      Series series = new Series(seriesId: null, name: "Haikyuu", url: "https://series.sx/stream/haikyuu", photoUrl: null);
      int seriesIndex = await database.seriesDb.insertSeries(series);
      Series dbSeries = (await database.seriesDb.findSeriesById(seriesIndex))!;

      expectLater(dbSeries.name, series.name,reason: "Series name is not same");

      dbSeries.setInitWatching(episode: 1,season: 5);
      await database.seriesDb.updateSeries(dbSeries);
      Series newDbSeries = (await database.seriesDb.findSeriesByName("%Haik%"))!.first;   //todo change in db %

      expectLater(newDbSeries.name, series.name, reason: "Updated series name is not right");
      expectLater(newDbSeries.season, 5, reason: "Season from series is not same");

      List<Series> list = await database.seriesDb.getAllSeries();

      expectLater(list.length, 1, reason: "Series List is not 1");
      await database.close();
      print("database test Series success");
    });

    test("database test Category", () async {
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      Category category = new Category(name: "Action");
      int categoryIndex = await database.categoryDb.insertCategory(category);

      List<Category> list = await database.categoryDb.getAllCategory();
      Category dbCategory = list.firstWhere((element) => element.categoryId == categoryIndex);


      expectLater(dbCategory.name, category.name,reason: "Category name is not same");
      expectLater(list.length, 1, reason: "Category List is not 1");
      await database.close();
      print("database test Category success");
    });

    test("database test SeriesCategoryHistory", () async {
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      Category category = new Category(name: "Action");
      Series series = new Series(seriesId: null, name: "Haikyuu", url: "https://series.sx/stream/haikyuu");
      int categoryIndex = await database.categoryDb.insertCategory(category);
      int seriesIndex = await database.seriesDb.insertSeries(series);
      SeriesCategoryHistory scHistory = new SeriesCategoryHistory(categoryId: categoryIndex, seriesId: seriesIndex);
      await database.seriesCategoryHistoryDb.insertCategorySeries(scHistory);
      List<SeriesCategoryHistory> history = await database.seriesCategoryHistoryDb.getAllSeriesCategoryHistory();
      SeriesCategoryHistory newHistory = history.first;
      
      expectLater(history.length, 1, reason: "History is not same");
      expect(newHistory.categoryId, categoryIndex, reason: "History categoryId is not same");
      expect(newHistory.seriesId, seriesIndex, reason: "History seriesId is not same");
      await database.close();
      print("database test SeriesCategoryHistory success");
    });

    test("database test stream", () async {
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      await database.categoryDb.insertCategories([
        new Category(name: "Drama"),
        new Category(name: "Comedy"),
        new Category(name: "Adventure"),
        new Category(name: "SciFi"),
      ]);
      List<Category> c = await database.categoryDb.getAllCategory();
      expectLater(c.length, 4, reason: "length is not correct");

      print("In Stream");

      Stream controller = database.categoryDb.getAllCategoryByStream();
      controller.listen((event) {
        for (Category value in event){
          print(value.name);
        }
      }, onDone: () {
        print("done");
        database.close();
      });
      print("database test streamsuccess");
    });
  });
}

/*test("test example for hoster",() {
      List<Map<int,String>> season = new List.generate(5, (index) {
        return {
          index: "hallo$index"
        };
      });
    });*/