import 'package:http/http.dart' as http;

class HttpService {
  static Future<String> httpClient(uri) async => await http
      .get(Uri.parse(uri), headers: {
    "Content-type": "application/xml",
    "Accept": "application/xml"
  })
      .then((value) => value.body)
      .then((value) => value.replaceAll("\r\n", '').replaceAll("\n", ''));
}
