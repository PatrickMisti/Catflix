import 'package:catflix/database/entities/series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchElementView extends StatelessWidget {
  @required
  final Series? series;

  const SearchElementView({this.series});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/detail", arguments: series),
          child: Container(
            color: Colors.tealAccent,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Image.network(series!.photoUrl!),
                Container(
                  width: 250,
                  child: Center(child: Text(series!.name, style: TextStyle(fontSize: 20),maxLines: 3)),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                )
              ],
            ),
          ),
        )
    );
  }
}