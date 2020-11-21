import 'package:flutter/material.dart';

import '../elements/CardsCarouselLoaderWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Market> marketsList;
  String heroTag;
  Key key;

  CardsCarouselWidget({this.key, this.marketsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.marketsList.length.toString()+'sdfghjkl;');
    return widget.marketsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : Container(
            height: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.marketsList.length,
              itemBuilder: (context, index) {
                //print(widget.marketsList.length.toString()+'aaaaaaaaaaaaaaaaaaaaa');
                print(widget.marketsList.elementAt(index).toMap());
                return GestureDetector(
                  onTap: () {
                   Navigator.of(context).pushNamed('/Menu', arguments: new RouteArgument(id: widget.marketsList.elementAt(index).id));
                  },
                  //child: Text('asda'),
                  child: CardWidget(market: widget.marketsList.elementAt(index), heroTag: widget.heroTag,key: widget.key,),
                );
              },
            ),
          );
  }
}
