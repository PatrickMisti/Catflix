import 'dart:async';
import 'package:catflix/database/entities/series.dart';
import 'package:catflix/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetailOs extends StatefulWidget {
  final Function choiceStream;
  final List<String> buttonList;
  final TargetPlatform platform;
  final Series series;

  DetailOs(
      {required this.buttonList, required this.choiceStream, required this.platform, required this.series});

  @override
  _DetailOs createState() => _DetailOs();
}

class _DetailOs extends State<DetailOs>{

  final Color _buttonColors = Colors.teal;
  final TextStyle _buttonForeStyle = TextStyle(color: CupertinoColors.white, fontSize: 18);

  Future<void> setCurrentSeries(context,String currentName, String currentUrl) async {
    widget.series.setInitWatching(currentName: currentName, currentUrl: currentUrl);
    await Provider.of(context).updateSeries(widget.series);
  }


  Future<void> showIosPopUp(context, List<Map> list) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: CupertinoColors.white.withOpacity(0.2),
            height: 250,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(

              ),
                itemExtent: 30,
                onSelectedItemChanged: (index) {},//todo
                children: List.generate(list.length, (index) {
                  List<String> convertedTextArray = list[index].keys.first.split('|');
                  String convertedText = "Season ${convertedTextArray[1]} Episode ${convertedTextArray[2]}";
                  return Text(convertedText, style: TextStyle(color: Colors.white));
                })
            ));
      },
    );
  }

  Future<void> showAndroidPopUp(context, List<Map> list){
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white.withOpacity(0.2),
        builder: (BuildContext context) {
          return Container(
            height: 350,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                List<String> convertedTextArray = list[index].keys.first.split('|');
                String convertedText = "";

                if(convertedTextArray[0].contains("Movie")) convertedText = "Movie ${convertedTextArray[2]}";
                else convertedText = "Season ${convertedTextArray[1]} Episode ${convertedTextArray[2]}";

                return ListTile(//todo update ui
                  onTap: () {
                    setCurrentSeries(context, list[index].keys.first, list[index].values.first)
                        .then((value) {
                          print("save");
                          setState(() {});
                    });
                  },
                  title: Center(child: Text(convertedText,style: TextStyle(color: list[index].keys.first == widget.series.currentSeriesName?Colors.blue:Colors.white),)),
                );
              },
            ),
          );
        },
    );
  }

  CupertinoButton buttonStyleIos(context, String name) {
    return CupertinoButton(
      color: _buttonColors,
      onPressed: () => _onPressedFunction(context,TargetPlatform.iOS,name),
      child: _buttonStyleText(name)
    );
  }
  //todo if pressed than onPressed to null
  ElevatedButton buttonStyleAndroid(context, String name) {
    return ElevatedButton(
        onPressed: () => _onPressedFunction(context,TargetPlatform.android,name),
        child: _buttonStyleText(name),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_buttonColors)),
    );
  }

  _onPressedFunction (context,TargetPlatform platform, String name) {
    List<Map> items = <Map>[];
    Stream stream = widget.choiceStream(name);

    StreamSubscription streamSubscription = stream.listen((event) => null);

    streamSubscription.onData((data) {
      items.add(data);
    });

    streamSubscription.onDone(() {
      if (platform == TargetPlatform.iOS)
        showIosPopUp(context,items).then((value) {
          streamSubscription.cancel();
          items = <Map>[];
        });

      else
        showAndroidPopUp(context, items).then((value) {
          streamSubscription.cancel();
          items = <Map>[];
        });
    });


    //showIosPopUp(context, )
  }

  Center _buttonStyleText (String name) => Center(child: Text(name,style: _buttonForeStyle));

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(widget.buttonList.length, (index) {
          String name = widget.buttonList[index];
          return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                child: widget.platform == TargetPlatform.iOS
                    ? buttonStyleIos(context,name)
                    : buttonStyleAndroid(context,name)
              ));
        })
    );
  }
}
