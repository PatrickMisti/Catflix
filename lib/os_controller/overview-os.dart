import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OsOverviewController extends StatefulWidget {
  final TargetPlatform os;
  final urlInputController = TextEditingController();
  final Function saveUrlToDb;

  OsOverviewController({required this.os, required this.saveUrlToDb});

  @override
  State<StatefulWidget> createState() => os == TargetPlatform.iOS
      ? _OsOverviewControllerIos()
      : _OsOverViewControllerAndroid();

  saveUrlToDatabase(
      String url, BuildContext context, Function errorDialog) async {
    Map<bool, String> result = await saveUrlToDb(url);
    Future.delayed(Duration(milliseconds: 500));

    if (!result.keys.first) return errorDialog(result.values.first);
    Navigator.pop(context);
  }
}

class _OsOverviewControllerIos extends State<OsOverviewController> {
  clearInput() {
    setState(() => widget.urlInputController.text = "");
  }

  Future showAlertDialog(String alerts) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Error"),
        content: Text(alerts),
        actions: [
          CupertinoDialogAction(
              child: Text("Ok"), onPressed: () => Navigator.pop(context))
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoAlertDialog(
      title: Text("Add Series"),
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: CupertinoTextField(
          controller: widget.urlInputController,
          placeholder:
              "Beispiel 'http://serienstream.sx/serie\n/stream/the-walking-dead/'",
          maxLines: 4,
          decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.black, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white70),
        ),
      ),
      actions: [
        CupertinoDialogAction(
            child: Text("Cancel"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              clearInput();
            }),
        CupertinoDialogAction(
            child: Text("Save"),
            onPressed: () {
              if (widget.urlInputController.text.length > 0)
                widget.saveUrlToDatabase(
                    widget.urlInputController.text, context, showAlertDialog);
              clearInput();
            })
      ],
    );
  }
}

class _OsOverViewControllerAndroid extends State<OsOverviewController> {
  clearInput() {
    setState(() => widget.urlInputController.text = "");
  }

  showAlertDialog(String alert) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Error"),
          children: [
            Column(
              children: [
                Text(alert,style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Ok"),
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.teal,
      title: Text("Add Series", style: TextStyle(color: Colors.white)),
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: widget.urlInputController,
          maxLines: 4,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black),
              hintText:
                  "Beispiel 'http://serienstream.sx/serie\n/stream/the-walking-dead/'"),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.urlInputController.text = "";
            },
            child: Text("Cancel"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white))),
        ElevatedButton(
            onPressed: () {
              if (widget.urlInputController.text.length > 0)
                widget.saveUrlToDatabase(
                    widget.urlInputController.text, context, showAlertDialog);
              clearInput();
            },
            child: Text("Save"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                foregroundColor: MaterialStateProperty.all(Colors.white)))
      ],
    );
  }
}
