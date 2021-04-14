import 'package:catflix/database/db/catflix_database.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await $FloorCatflixDatabase.databaseBuilder("catflix.db").build();
  //await db.categoryDb.deleteAllCategories();
  runApp(Home(db));
}

class Home extends StatelessWidget{
  final CatflixDatabase db;
  Home(this.db);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Provider(
      osX: Theme.of(context).platform,
      db: db,
      child: CupertinoApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        initialRoute: '/',
        onGenerateRoute: RouterGenerator.generateRoute,
      ),
    );
  }
}
