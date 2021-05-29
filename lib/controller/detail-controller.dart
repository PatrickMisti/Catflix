import 'dart:convert';
import 'package:catflix/utilities/http-service.dart';
import 'package:html/dom.dart';
import 'package:xml2json/xml2json.dart';
import 'package:html/parser.dart' show parse;

class DetailController{
  late String _streamUrl;
  late Map<String,dynamic> buttons;

  DetailController() {
    buttons = new Map<String,dynamic>();
  }

  String get streamOriginalUrl => this._streamUrl;

  void dispose() => buttons.clear();

  Future<List<String>> getButtonTextWithUrl(String url) async {
    _setUrl(url);

    List<Element> list = await _getResponseConvertToListElement(url);
    List<Element> checkIfMovie = list.where((element) => element.innerHtml.contains('Filme') || element.innerHtml.contains('Movie')).toList();

    if (checkIfMovie.isNotEmpty) {
      List<Map> movieResult = checkIfMovie.map((e) => _convertLinkToMap(e)).toList();
      buttons.addAll({'Movie': movieResult.map((e) => e['href'].toString()).toList()});
      list.remove(checkIfMovie.first);
    }
    List<Map> seriesList = list.map((e) => _convertLinkToMap(e)).toList();
    buttons.addAll({'Series': seriesList.map((e) => e['href'].toString()).toList()});

    return buttons.keys.toList();
  }

  Stream<Map<String,String>> getSeriesFromButtonStream(String choice) async* {
    List<String> choiceList = buttons[choice];
    int season = 0;
    for (String url in choiceList) {
      season++;
      String key = "$choice|$season";
      List<Element> seriesList = await _getResponseConvertToListElement(_streamUrl + url,1);
      if (seriesList.isEmpty)
        continue;
      List<Map> seriesMapList = seriesList.map((e) => _convertLinkToMap(e)).toList();
      int episode = 0;
      for (Map item in seriesMapList) {
        episode++;
        yield {"$key|$episode":_streamUrl + item['href']};
      }
    }
  }

  Future<List<Element>> _getResponseConvertToListElement(String url, [int index = 0]) async {
    Document html = parse(await HttpService.httpClient(url));
    List<Element> xmlUl= html.getElementById('stream')!.getElementsByTagName('ul');
    xmlUl[index].nodes.removeWhere((element) => element is Text);
    List<Element> xmlAList = xmlUl[index].getElementsByTagName('a');
    return xmlAList;
  }

  void _setUrl(String url){
    List<String> raw = url.split('/');
    _streamUrl = "${raw[0]}//${raw[2]}";
  }

  Map _convertLinkToMap(Element element) {
    final xml2json = Xml2Json();
    xml2json.parse(element.outerHtml);
    String jsonStringRaw = xml2json.toGData();
    Map json = jsonDecode(jsonStringRaw)['a'];
    return json;
  }

  // url = https://serien.sx/serie/stream/fate-the-winx-saga/staffel-1/episode-1
  static Future<List<Map>> getHostAndLanguageForSeries(String url,String original) async{

    List<Map<String,dynamic>> manager = <Map<String, dynamic>>[];
    Document html = parse(await HttpService.httpClient(url));
    
    List<Element> links = html
        .getElementsByClassName("hosterSiteVideo")[0]
        .getElementsByClassName("row")[0]
        .getElementsByTagName("li");

    List<Map<String,dynamic>> linkTarget = links.map((e) {
      List aRef = e.getElementsByTagName('h4');
      String i = aRef[0].nodes.first.text!;

      return {
        "langKey": e.attributes['data-lang-key'],
        "dataLink": original + e.attributes['data-link-target'].toString(),
        "name": i
      };
    }).toList();

    List<Element> language = html
        .getElementsByClassName("changeLanguageBox")[0]
        .getElementsByTagName("img");

    manager = language.map((item) {

      List<Map> links = <Map>[];

      for(var element in linkTarget)
        if(int.parse(element['langKey']) == int.parse(item.attributes['data-lang-key'].toString()))
          links.add(element);


      return {
        "images": original + item.attributes['src'].toString(),
        "langKey": int.parse(item.attributes['data-lang-key'].toString()),
        "link": links
      };
    }).toList();
    return manager;
  }
}