import 'package:catflix/database/entities/series.dart';
import 'package:catflix/view/detail/detail.dart';
import 'package:catflix/view/overview/overview.dart';
import 'package:catflix/view/search/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class RouterGenerator  {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case "/":
        return CupertinoPageRoute(builder: (context) => Overview());
      case "/detail":
        return CupertinoPageRoute(builder: (context) => Detail(args as Series));
      case "/search":
        return PageTransition(child: Search(), type: PageTransitionType.fade);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (context) =>
        Scaffold(
          appBar: CupertinoNavigationBar(
            middle: Text("Error"),
          ),
          body: Center(
            child: Text('Page not found!'),
          ),
        ));
  }
}