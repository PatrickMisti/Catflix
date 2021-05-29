import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HostedUrlToSeries extends StatefulWidget{
  final List<Map> _linkList;

  HostedUrlToSeries(this._linkList);

  @override
  _HostedUrlToSeries createState() => _HostedUrlToSeries();
}

class _HostedUrlToSeries extends State<HostedUrlToSeries> {

  int segmentControlValue = 0;

  launchUrlToBrowser(String hostUrl) async {
    if (await canLaunch(hostUrl))
      await launch(hostUrl,forceSafariVC: true,forceWebView: true,enableJavaScript: true);
    else
      throw 'Could not launch $hostUrl';
  }

  buildHostUi(String browserUrl,String name) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () => launchUrlToBrowser(browserUrl),
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(
                color: CupertinoColors.white,
                width: 4,
                style: BorderStyle.solid)),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  name,
                  style:
                  TextStyle(color: CupertinoColors.white, fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: Icon(
                Icons.play_arrow_outlined,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: widget._linkList.length > 1
                  ?CupertinoSlidingSegmentedControl<int>(
                  groupValue: segmentControlValue,
                  backgroundColor: Colors.teal,
                  children: Map.fromIterable(widget._linkList, key: (k) => widget._linkList.indexOf(k), value: (v) => Container(height: 30,child: Image.network(v['images']),)),
                  onValueChanged: (value) {
                    setState(() {
                      segmentControlValue = value!;
                    });
                  }
              )
                  :Container(
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(child: Image.network(widget._linkList.first['images'])),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemExtent: 80,
                  itemCount: widget._linkList[segmentControlValue]['link'].length,
                  itemBuilder: (context, index) {
                    List<Map> linksList = widget._linkList[segmentControlValue]['link'];
                    Map element = linksList[index];
                    return buildHostUi(element['dataLink'], element['name']);
                  },
                )
            )
          ],
        )
    );
  }
}