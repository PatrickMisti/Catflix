import 'package:catflix/database/db/catflix_database.dart';
import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catflix/utilities/http-convert-sql.dart';

void main() {
  // save two urls with same input but other link nevertheless save item

  group("Database and http", () {
    test("data save in db", () async{
      final url = "https://serien.sx/serie/stream/the-crew-2021";
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      Map<bool,String> success = await database.saveDataIntoDb(url);

      expectLater(success.keys.first, true, reason: success.values.first);

      List<Category> category = await database.categoryDb.getAllCategory();
      List<Series> series = await database.seriesDb.getAllSeries();
      List<SeriesCategoryHistory> sch = await database.seriesCategoryHistoryDb.getAllSeriesCategoryHistory();

      expectLater(category.length, 2,reason: "Length of categroylist is not 2");
      expectLater(series.length, 1,reason: "Length of series is not 1");
      expectLater(sch.length, 2,reason: "Length of sch is not 2");
      print("data save in db success");
      await database.close();
    });
    test("save more data in db", () async {
      final url1 = "https://serien.sx/serie/stream/dgray-man-hallow";
      final url2 = "https://serien.sx/serie/stream/jujutsu-kaisen";
      final url3 = "https://serien.sx/serie/stream/11eyes";
      final url4 = "https://serien.sx/serie/stream/243-seiin-high-school-boys-volleyball-team";

      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();

      expectLater((await database.saveDataIntoDb(url1)).keys.first, true);
      expectLater((await database.saveDataIntoDb(url2)).keys.first, true);
      expectLater((await database.saveDataIntoDb(url3)).keys.first, true);
      expectLater((await database.saveDataIntoDb(url4)).keys.first, true);

      List<Category> category = await database.categoryDb.getAllCategory();
      List<Series> series = await database.seriesDb.getAllSeries();
      List<SeriesCategoryHistory> sch = await database.seriesCategoryHistoryDb.getAllSeriesCategoryHistory();

      expectLater(category.length, 6,reason: "Length of categroylist is not 6");
      expectLater(series.length, 4,reason: "Length of series is not 4");
      expectLater(sch.length, 11,reason: "Length of sch is not 11");
      print("data save in db success");
      await database.close();
    });
    test("save data in db but with error building", () async{
      final url1 = "https://serien.sx/serie/stream/mushoku-tensei-isekai-ittara-honki-dasu/staffel-1/episode-11";
      final url2 = "https://serien.sx/serie/stream/haikyuu";
      final url3 = "https://serien.sx/serie/stream/mushoku-tensei-isekai-ittara-honki-dasu/";
      final url4 = "https://anicloud.io/anime/stream/the-hidden-dungeon-only-i-can-enter";
      final url5 = "";
      final url6 = "https://anicloud.io/anime/stream/";
      final url7 = "serie/stream/mushoku-tensei-isekai-ittara-honki-dasu/staffel-1/episode-11/";
      
      final database = await $FloorCatflixDatabase.inMemoryDatabaseBuilder().build();
      
      expectLater((await database.saveDataIntoDb(url1)).keys.first, true, reason: "can not save first url");
      expectLater((await database.saveDataIntoDb(url2)).keys.first, true, reason: "can not save second url");
      Map<bool,String> third = await database.saveDataIntoDb(url3);
      expectLater(third.keys.first, false, reason: "should not save third url");
      expectLater(third.values.first, "Series even exists!", reason: "third url exists");
      expectLater((await database.saveDataIntoDb(url4)).keys.first, true, reason: "can not save fourth url");
      Map<bool,String> fifthUrl = await database.saveDataIntoDb(url5);
      expectLater(fifthUrl.keys.first, false, reason: "url five is empty");
      expectLater(fifthUrl.values.first, "Url is empty", reason: "url five is empty values");
      Map<bool,String> sixthUrl = await database.saveDataIntoDb(url6);
      expectLater(sixthUrl.keys.first, false, reason: "url six is wrong");
      expectLater(sixthUrl.values.first, "Url is not correct!", reason: "url six is wrong values");
      Map<bool,String> seventhUrl = await database.saveDataIntoDb(url7);
      expectLater(seventhUrl.keys.first, false, reason: "url seven is wrong");
      expectLater(seventhUrl.values.first, "Url is not correct!", reason: "url seven is wrong values");
    });
  });
}
