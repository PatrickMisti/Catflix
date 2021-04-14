import 'package:catflix/database/entities/series.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/view/search/search-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  String? input;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.teal,
        leading: GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context,"/"),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        middle: CupertinoTextField(
          placeholder: "Input",
          placeholderStyle: TextStyle(color: Colors.tealAccent),
          onChanged: (value) {
            setState(() {
              input = value;
            });
          },
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: BoxDecoration(color: Colors.teal),
        ),
      ),
      body: input != null
          ? input!.isNotEmpty
              ? FutureBuilder(
                  future: Provider.of(context)
                      .findSeriesByName(input!),
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: (snapshot.data as List<Series>).length,
                            itemBuilder: (_, index) => SearchElementView(
                                series: (snapshot.data as List<Series>)[index]),
                          )
                        : Center(child: CupertinoActivityIndicator());
                  },
                )
              : Container()
          : Container(),
    );
  }
}
