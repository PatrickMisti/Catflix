import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetailOs extends StatelessWidget{
  final Function choiceStream;
  final List<String> buttonList;
  final TargetPlatform platform;

  DetailOs({required this.buttonList, required this.choiceStream, required this.platform});


  final Color _buttonColors = Colors.teal;
  final TextStyle _buttonForeStyle = TextStyle(color: CupertinoColors.white, fontSize: 18);

  Future<void> showIosPopUp(context, List<Map> list) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: CupertinoColors.white.withOpacity(0.2),
            height: 250,
            child: CupertinoPicker(
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
                String convertedText = "Season ${convertedTextArray[1]} Episode ${convertedTextArray[2]}";
                return ListTile( //todo
                  title: Center(child: Text(convertedText,style: TextStyle(color: Colors.white),)),
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

  ElevatedButton buttonStyleAndroid(context, String name) {
    return ElevatedButton(
        onPressed: () => _onPressedFunction(context,TargetPlatform.android,name),
        child: _buttonStyleText(name),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_buttonColors)),
    );
  }

  _onPressedFunction (context,TargetPlatform platform, String name) {
    List<Map> items = <Map>[];
    Stream stream = choiceStream(name);

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
        children: List.generate(buttonList.length, (index) {
          String name = buttonList[index];
          return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                child: platform == TargetPlatform.iOS
                    ? buttonStyleIos(context,name)
                    : buttonStyleAndroid(context,name)
              ));
        })
    );
  }
}
