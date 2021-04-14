// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catflix_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorCatflixDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$CatflixDatabaseBuilder databaseBuilder(String name) =>
      _$CatflixDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$CatflixDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$CatflixDatabaseBuilder(null);
}

class _$CatflixDatabaseBuilder {
  _$CatflixDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$CatflixDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$CatflixDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<CatflixDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CatflixDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CatflixDatabase extends CatflixDatabase {
  _$CatflixDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SeriesDao? _seriesDbInstance;

  CategoryDao? _categoryDbInstance;

  SeriesCategoryHistoryDao? _seriesCategoryHistoryDbInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Series` (`seriesId` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `url` TEXT NOT NULL, `photoUrl` TEXT, `season` INTEGER NOT NULL, `episode` INTEGER NOT NULL, `movie` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`categoryId` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SeriesCategoryHistory` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `categoryId` INTEGER NOT NULL, `seriesId` INTEGER NOT NULL, FOREIGN KEY (`categoryId`) REFERENCES `Category` (`categoryId`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`seriesId`) REFERENCES `Series` (`seriesId`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SeriesDao get seriesDb {
    return _seriesDbInstance ??= _$SeriesDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDb {
    return _categoryDbInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  SeriesCategoryHistoryDao get seriesCategoryHistoryDb {
    return _seriesCategoryHistoryDbInstance ??=
        _$SeriesCategoryHistoryDao(database, changeListener);
  }
}

class _$SeriesDao extends SeriesDao {
  _$SeriesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _seriesInsertionAdapter = InsertionAdapter(
            database,
            'Series',
            (Series item) => <String, Object?>{
                  'seriesId': item.seriesId,
                  'name': item.name,
                  'url': item.url,
                  'photoUrl': item.photoUrl,
                  'season': item.season,
                  'episode': item.episode,
                  'movie': item.movie
                },
            changeListener),
        _seriesUpdateAdapter = UpdateAdapter(
            database,
            'Series',
            ['seriesId'],
            (Series item) => <String, Object?>{
                  'seriesId': item.seriesId,
                  'name': item.name,
                  'url': item.url,
                  'photoUrl': item.photoUrl,
                  'season': item.season,
                  'episode': item.episode,
                  'movie': item.movie
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Series> _seriesInsertionAdapter;

  final UpdateAdapter<Series> _seriesUpdateAdapter;

  @override
  Future<List<Series>> getAllSeries() async {
    return _queryAdapter.queryList('Select * from Series',
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Stream<List<Series>> getAllSeriesByStream() {
    return _queryAdapter.queryListStream('Select * from Series',
        queryableName: 'Series',
        isView: false,
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Stream<List<Series>> getAllSeriesFromCategoryIdByStream(int id) {
    return _queryAdapter.queryListStream(
        'Select s.* from SeriesCategoryHistory cs left outer join Series s on s.seriesId = cs.seriesId where cs.categoryId = ?',
        arguments: [id],
        queryableName: 'Series',
        isView: false,
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Future<List<Series>?> getSeriesFromUrlCompare(String video) async {
    return _queryAdapter.queryList('Select * from Series where url = ?',
        arguments: [video],
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Future<List<Series>?> findSeriesByName(String input) async {
    return _queryAdapter.queryList('Select * from Series where name Like ?',
        arguments: [input],
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Future<Series?> findSeriesById(int id) async {
    return _queryAdapter.query('Select * from Series where seriesId = ?',
        arguments: [id],
        mapper: (Map<String, Object?> row) => Series(
            seriesId: row['seriesId'] as int?,
            name: row['name'] as String,
            url: row['url'] as String,
            photoUrl: row['photoUrl'] as String?,
            season: row['season'] as int,
            episode: row['episode'] as int,
            movie: row['movie'] as int));
  }

  @override
  Future<void> deleteSeries(int id) async {
    await _queryAdapter
        .queryNoReturn('Delete from Series where seriesId = ?', arguments: [id]);
  }

  @override
  Future<void> deleteAllSeries() async {
    await _queryAdapter.queryNoReturn('Delete from Series');
  }

  @override
  Future<int> insertSeries(Series series) {
    return _seriesInsertionAdapter.insertAndReturnId(
        series, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSeries(Series series) async {
    await _seriesUpdateAdapter.update(series, OnConflictStrategy.fail);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) => <String, Object?>{
                  'categoryId': item.categoryId,
                  'name': item.name
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  @override
  Future<List<Category>> getAllCategory() async {
    return _queryAdapter.queryList('Select * from Category',
        mapper: (Map<String, Object?> row) => Category(
            categoryId: row['categoryId'] as int?,
            name: row['name'] as String));
  }

  @override
  Stream<List<Category>> getAllCategoryByStream() {
    return _queryAdapter.queryListStream('Select * from Category',
        queryableName: 'Category',
        isView: false,
        mapper: (Map<String, Object?> row) => Category(
            categoryId: row['categoryId'] as int?,
            name: row['name'] as String));
  }

  @override
  Future<List<Category>?> getCategoriesFromListCategory(
      List<String> names) async {
    final valueList0 = names.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'Select * from Category where name IN ($valueList0)',
        mapper: (Map<String, Object?> row) => Category(
            categoryId: row['categoryId'] as int?,
            name: row['name'] as String));
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _queryAdapter.queryNoReturn(
        'Delete from Category where categoryId = ?',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllCategories() async {
    await _queryAdapter.queryNoReturn('Delete from Category');
  }

  @override
  Future<int> insertCategory(Category category) {
    return _categoryInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertCategories(List<Category> categories) {
    return _categoryInsertionAdapter.insertListAndReturnIds(
        categories, OnConflictStrategy.abort);
  }
}

class _$SeriesCategoryHistoryDao extends SeriesCategoryHistoryDao {
  _$SeriesCategoryHistoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _seriesCategoryHistoryInsertionAdapter = InsertionAdapter(
            database,
            'SeriesCategoryHistory',
            (SeriesCategoryHistory item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'seriesId': item.seriesId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SeriesCategoryHistory>
      _seriesCategoryHistoryInsertionAdapter;

  @override
  Future<List<SeriesCategoryHistory>> getAllSeriesCategoryHistory() async {
    return _queryAdapter.queryList('Select * from SeriesCategoryHistory',
        mapper: (Map<String, Object?> row) => SeriesCategoryHistory(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            seriesId: row['seriesId'] as int));
  }

  @override
  Stream<List<SeriesCategoryHistory>> getAllSeriesCategoryHistoryByStream() {
    return _queryAdapter.queryListStream('Select * from SeriesCategoryHistory',
        queryableName: 'SeriesCategoryHistory',
        isView: false,
        mapper: (Map<String, Object?> row) => SeriesCategoryHistory(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            seriesId: row['seriesId'] as int));
  }

  @override
  Future<SeriesCategoryHistory?> getSeriesCategoryHistoryById(int id) async {
    return _queryAdapter.query(
        'Select * from SeriesCategoryHistory where id = ?',
        arguments: [id],
        mapper: (Map<String, Object?> row) => SeriesCategoryHistory(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            seriesId: row['seriesId'] as int));
  }

  @override
  Future<List<SeriesCategoryHistory>?> getCategoryFromSeriesId(
      int seriesId) async {
    return _queryAdapter.queryList(
        'Select * from SeriesCategoryHistory where seriesId = ?',
        arguments: [seriesId],
        mapper: (Map<String, Object?> row) => SeriesCategoryHistory(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            seriesId: row['seriesId'] as int));
  }

  @override
  Future<List<SeriesCategoryHistory>?> getSeriesFromCategoryId(
      int categoryId) async {
    return _queryAdapter.queryList(
        'Select * from SeriesCategoryHistory where categoryId = ?',
        arguments: [categoryId],
        mapper: (Map<String, Object?> row) => SeriesCategoryHistory(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            seriesId: row['seriesId'] as int));
  }

  @override
  Future<void> deleteSeriesCategoryHistoryById(int id) async {
    await _queryAdapter.queryNoReturn(
        'Delete from SeriesCategoryHistory where id = ?',
        arguments: [id]);
  }

  @override
  Future<void> deleteSeriesCategoryHistoryFromSeriesId(int id) async {
    await _queryAdapter.queryNoReturn(
        'Delete from SeriesCategoryHistory where seriesId = ?',
        arguments: [id]);
  }

  @override
  Future<void> deleteSeriesCategoryHistory() async {
    await _queryAdapter.queryNoReturn('Delete from SeriesCategoryHistory');
  }

  @override
  Future<int> insertCategorySeries(
      SeriesCategoryHistory seriesCategoryHistory) {
    return _seriesCategoryHistoryInsertionAdapter.insertAndReturnId(
        seriesCategoryHistory, OnConflictStrategy.abort);
  }
}
