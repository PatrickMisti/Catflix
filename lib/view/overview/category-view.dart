import 'package:catflix/database/entities/category.dart';
import 'package:catflix/provider.dart';
import 'package:catflix/utilities/Observer.dart';
import 'package:catflix/view/overview/series-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  //todo Stateful for feature
  /*viewActivityIndicatorOrText() async{
    var component = Center(child: CupertinoActivityIndicator(),);
    await Future.delayed(Duration(seconds: 15)).then((value) => setState((){
      component = Center(child: Text("No elements"))
    }));
  }*/

  @override
  Widget build(BuildContext context) {
    return Observer<List<Category>>(
      onWaiting: Provider.of(context).osX,
      stream: Provider.of(context).getCategoryStream,
      onSuccess: (context, List<Category> data) {
        if (data.length == 0)
          return Container(child: Center(child: Text("No Element",style: TextStyle(color: Colors.white),)));

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          data[index].name,
                          style: TextStyle(
                              color: CupertinoColors.white, fontSize: 20),
                        )),
                    Flexible(child: SeriesView(data[index].categoryId!))
                  ],
                ),
              );
            });
      },
    );

  }
}