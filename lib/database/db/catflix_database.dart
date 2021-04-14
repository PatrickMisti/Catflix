import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:catflix/database/db/categoryDAO.dart';
import 'package:catflix/database/db/seriesDAO.dart';
import 'package:catflix/database/db/series_category_historyDAO.dart';
import 'package:catflix/database/entities/category.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/database/entities/seriescategoryHistory.dart';
import 'package:floor/floor.dart';

part 'catflix_database.g.dart';

@Database(version: 1, entities: [Series,Category,SeriesCategoryHistory])
abstract class CatflixDatabase extends FloorDatabase {
  SeriesDao get seriesDb;
  CategoryDao get categoryDb;
  SeriesCategoryHistoryDao get seriesCategoryHistoryDb;
}