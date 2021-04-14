import 'package:catflix/database/entities/series.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/utilities/Observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeriesView extends StatelessWidget {
  final int _categoryId;

  SeriesView(this._categoryId);

  Container seriesViewStyle(Series series){
    return Container(
        child: Column(
          children: [
            series.photoUrl!.isNotEmpty
                ? Container(height: 190, width: 150,
                decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    image: DecorationImage(image: Image.network(series.photoUrl!).image)))
                : Container(
                height: 200,
                width: 150,
                child: Center(child: Text("No Photo")),
                color: Colors.blue),
            Container(width: 200,child: Center(child: Text(series.name, style: TextStyle(color: Colors.teal)))),
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    int _indexOfItem = 0;

    return Observer<List<Series>>(
        onWaiting: Provider.of(context).osX,
        stream: Provider.of(context).getSeriesFromCategoryStream(_categoryId),
        onSuccess: (context, List<Series> data) {
          return RotatedBox(
            quarterTurns: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/detail",
                    arguments: data[_indexOfItem]);
              },
              child: ListWheelScrollView(
                onSelectedItemChanged: (indexOfWheel) =>
                _indexOfItem = indexOfWheel,
                diameterRatio: 2,
                itemExtent: 170,
                children: List<Widget>.generate(data.length, (index) {
                  Series series = data[index];
                  return new RotatedBox(
                    quarterTurns: 1,
                    child: seriesViewStyle(series),
                  );
                }),
              ),
            ),
          );
        });

  }
}