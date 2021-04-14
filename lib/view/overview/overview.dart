import 'package:catflix/os_controller/overview-os.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/view/overview/category-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> with TickerProviderStateMixin, SingleTickerProviderStateMixin {
  Future<Map<bool, String>> saveUrl(String url) async =>
     await Provider.of(context).setSeriesUrl(url);

  dialogAction(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            OsOverviewController(os: Provider.of(context).osX, saveUrlToDb: saveUrl)
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.teal,
          middle: Text("Serien", style: TextStyle(color: CupertinoColors.white)),
          leading: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, "/search"),
            child: Icon(Icons.search,color: CupertinoColors.white),
          ),
          trailing: GestureDetector(
            onTap: () => dialogAction(),
            child: Icon(Icons.add,color: CupertinoColors.white),
          ),
        ),
        child: CategoryView()
    );
  }
}