import 'package:catflix/controller/detail-controller.dart';
import 'package:catflix/utilities/Observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home: TestingView(),));
}

class TestingView extends StatelessWidget {
  final url = "https://serien.sx/serie/stream/the-crew-2021";

  getStreams(String name,DetailController controller) {
    var stream = controller.getSeriesFromButtonStream(name);
    stream.listen((event) {
      print(event.entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    DetailController controller = new DetailController();

    return Scaffold(
      body: FutureBuilder(
        future: controller.getButtonTextWithUrl(url),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            List<String> items = snapshot.data as List<String>;

            getStreams(items.first, controller);
            return Container();
          }
          return Container(child: Text("Waiting"),);
        },
      ),
    );
  }
}
