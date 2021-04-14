import 'file:///C:/Home/Github/Catflix/catflix/lib/controller/detail-controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("get xml from url", (){
    test("test", () async {
      final url = "https://serienstream.sx/serie/stream/boku-no-hero-academia";
      DetailController controller = new DetailController();
      var i = await controller.getButtonTextWithUrl(url);

      expectLater(i.length, 2);
    });
  });
}