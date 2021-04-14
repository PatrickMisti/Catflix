import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  @required
  final Stream<T> stream;
  @required
  final Function onSuccess;

  final Function? onError;

  final TargetPlatform onWaiting;

  Observer({required this.stream,required this.onSuccess, this.onError, required this.onWaiting});

  Function _onDefaultError(error) => (context, error) => log("error");

  Widget get _onDefaultWaitingIos =>
           Center(child: CupertinoActivityIndicator());

  Widget get _onDefaultWaitingAndroid =>
           Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError)
          return onError != null
              ? _onDefaultError(snapshot.error)
              : onError!(context, snapshot.error);

        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return onWaiting == TargetPlatform.iOS ? _onDefaultWaitingIos : _onDefaultWaitingAndroid;
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.data != null)
              return onSuccess(context, snapshot.data as T);
        }
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}