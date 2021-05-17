import 'package:catflix/controller/detail-controller.dart';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/os_controller/detail-os.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/view/detail/hosted-url-series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final Series _series;

  const Detail(this._series);

  @override
  Widget build(BuildContext context) {
    DetailController detailController = new DetailController();
    TargetPlatform platform = Provider.of(context).osX;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.teal,
        trailing: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Provider.of(context).deleteSeriesById(_series.seriesId!);
            },
          child: Icon(Icons.delete, color: CupertinoColors.white),
        ),
        middle: Text(_series.name, style: TextStyle(color: CupertinoColors.white)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: CupertinoColors.white,),
        ),
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .35,
              width: MediaQuery.of(context).size.width,
              child: _series.photoUrl != null
                  ? Image.network(_series.photoUrl!)
                  : Center(child: Text("No Photo")),
            ),
            FutureBuilder(
              future: detailController.getButtonTextWithUrl(this._series.url),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data != null
                      ? Container(
                          child: new DetailOs(
                              buttonList: snapshot.data as List<String>,
                              choiceStream: (String name) {
                                return detailController.getSeriesFromButtonStream(name);
                              },
                              platform: platform),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10),)
                      : Container(child: Center(child: Text("No Element")));
                }
                return Container(height: 50,child: Center(child: CupertinoActivityIndicator()));
              },
            ),
            HostedUrlToSeries()
          ],
        ),
      ),
    );
  }
}