import 'package:catflix/utilities/Observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailOs extends StatelessWidget {
  final List<String> buttonList;
  final TargetPlatform platform;
  final Color _buttonColors = Colors.teal;
  final TextStyle _buttonForeStyle = TextStyle(color: CupertinoColors.white, fontSize: 18);
  final Function choiceStream;

  DetailOs({required this.buttonList, required this.choiceStream, required this.platform});

  CupertinoButton buttonStyleIos(String name) {
    return CupertinoButton(
      color: _buttonColors,
      onPressed: () {
        List<Map<String,String>> items = <Map<String,String>>[];
        modalObserver(items, name);
      },
      child: Center(
        child: Text(
          name,
          style: _buttonForeStyle,
        ),
      ),
    );
  }

  showIosPopUp(context,List<Map<String, String>> series) {
    return showCupertinoModalPopup(context: context,
        builder: (BuildContext context) {
          return Container(
            color: CupertinoColors.white,
            height: 300,
            child: CupertinoPicker(
                /*scrollController: FixedExtentScrollController(
                    initialItem: video.indexOf(video
                        .where((element) => element.episodeId == widget._detailManager.getCurrentEpisode().episodeId)
                        .first)),*/
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  /*setState(() {
                    widget._detailManager.setCurrentEpisode(video[index]);
                  });*/
                },
                children: new List<Widget>.generate(series.length, (index) => Text(series[index].keys.first))),
          );
        });
  }


  ElevatedButton buttonStyleAndroid(String name) {
    return ElevatedButton(
        onPressed: (){
          List<Map<String,String>> items = <Map<String,String>>[];
          modalObserver(items, name);
        },
        child: Center(
          child: Text(
            name,
            style: _buttonForeStyle,
          ),
        ),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_buttonColors)),
    );
  }


  modalObserver(List<Map<String,String>> items,String name) {
    return Observer<Map<String,String>>(
        stream: choiceStream(name),
        onSuccess: (context, Map<String,String> item) {
          items.add(item);
          showIosPopUp(context, items);
        },
        onWaiting: platform
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(buttonList.length, (index) {
          String name = buttonList[index];
          return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                child: platform == TargetPlatform.iOS
                    ? buttonStyleIos(name)
                    : buttonStyleAndroid(name)
              ));
        })
    );
  }
}
