import 'package:catflix/database/db/categoryDAO.dart';
import 'package:catflix/database/db/catflix_database.dart';
import 'package:catflix/database/db/series_category_historyDAO.dart';
import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:catflix/utilities/http-service.dart';
import 'package:html/parser.dart' show parse;

extension ConvertHttpToSql on CatflixDatabase {

  Future<Map<bool,String>> saveDataIntoDb(String rawUrl) async {
    Map<bool,String> url = _verifyUrl(rawUrl);
    if(!url.keys.first) return url;

    List<Series> compareSeries = (await this.seriesDb.getSeriesFromUrlCompare(url.values.first))!;

    if (compareSeries.length == 0) {
      var result = await HttpService.httpClient(url.values.first);
      var header = await _htmlGetImageAndTitle(result, url.values.first);
      List<int> category = await _htmlGetCategoryFromSeries(this.categoryDb, result);
      var series = Series(
          name: header["title"],
          photoUrl: header["image"],
          url: url.values.first);
      int episodeId = await this.seriesDb.insertSeries(series);
      _saveCategoriesToSeries(this.seriesCategoryHistoryDb,episodeId,category);

      return ({true:"Success"});
    }
    else
      return ({false:"Series even exists!"});
  }

  Map<bool,String> _verifyUrl(String url) {
    if (url.isEmpty) return ({false:"Url is empty"});

    var rawUrl = url.split('/');
    if (rawUrl.last == "")
      rawUrl.removeAt(rawUrl.length - 1);

    if(rawUrl.length >= 6) {
      String result = rawUrl
          .sublist(0, 6)
          .join('/');
      return ({true:result});
    }
    return ({false: "Url is not correct!"});
  }

  void _saveCategoriesToSeries(SeriesCategoryHistoryDao dao,int episodeId, List<int> category) {
    category.forEach((element) async =>
        await dao.insertCategorySeries(new SeriesCategoryHistory(categoryId: element, seriesId: episodeId))
    );
  }

  Future<List<int>> _htmlGetCategoryFromSeries(CategoryDao dao, String result) async {
    var html = parse(result);
    var genre = html.querySelector('div.genres')!.getElementsByTagName('a');

    List<Category> categories = List.of(genre.map((e) => new Category(name: e.nodes[0].text!)));
    List<Category> savedCategories = await dao.getAllCategory();

    List<String> notExists = categories.map((e) => e.name).toSet()
        .difference(savedCategories.map((e) => e.name).toSet())
        .toList();

    List<Category> actualList = (await dao.getCategoriesFromListCategory(categories.map((e) => e.name).cast<String>().toList()))!;

    if(savedCategories.isEmpty)
      return await dao.insertCategories(categories);
    if (notExists.length != 0)
      return actualList.map((e) => e.categoryId).cast<int>().toList()
          + await dao.insertCategories(notExists.map((e) => new Category(name: e.toString())).toList());

    return actualList.map((e) => e.categoryId).cast<int>().toList();
  }

  Future<Map> _htmlGetImageAndTitle(String response, String uri) async {
    var html = parse(response);
    var title = html.querySelector("h1[title]")!
        .nodes[0]
        .nodes[0]
        .text; // titel von der Serie

    var imageUri = html
        .querySelector("div.seriesCoverBox")!
        .nodes[0]
        .attributes["data-src"]; //https://serienstream.sx/+ imageurl

    var basicUri = uri.split('/');
    var fullImageUri = basicUri[0].toString() +
        "//" +
        basicUri[2].toString() +
        imageUri.toString();

    return ({"title": title.toString(), "image": fullImageUri});
  }
}