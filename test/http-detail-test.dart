import 'package:catflix/controller/detail-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("get xml from url", (){
    test("test", () async {
      List<Map> list = await DetailController.getHostAndLanguageForSeries("https://serien.sx/serie/stream/fate-the-winx-saga/staffel-1/episode-1", "https://serien.sx");
      var i = Map.fromIterable(list,key: (k) => list.indexOf(k),value: (v) => Container(child: Image.network(v['images']),));
      print("hallo");
    });
  });
}