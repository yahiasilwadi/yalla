import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/field.dart';

import '../helpers/helper.dart';
import '../models/market.dart';
import '../models/route_argument.dart';

class GridViewOfMainFieldItem extends StatelessWidget {
  final Field field;
  final String heroTag;
  

  GridViewOfMainFieldItem({Key key, this.field, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // print(field.markets.length.toString()+'dfghjk');
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        if(field.id=='3'){
          print('jhgggggg');
          Navigator.of(context).pushNamed('/Menu', arguments: new RouteArgument(id: field.markets.elementAt(0).id));

        }else if (field.id=='4'){
          Navigator.of(context).pushNamed('/OrderAnything');

        }else{
        Navigator.of(context).pushNamed('/viewMarketsByCategory', arguments: RouteArgument(param: field));
     
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]),
        child: Wrap(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Hero(
                tag: 'heroTag' + field.id,
                child: CachedNetworkImage(
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: field.description,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 82,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Text(
            //         field.name,
            //         style: Theme.of(context).textTheme.bodyText2,
            //         softWrap: false,
            //         maxLines: 3,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       SizedBox(height: 2),
            //       Row(
            //       //  children: Helper.getStarsList(double.parse(field.rate)),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
