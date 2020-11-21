import 'package:flutter/material.dart';
import 'package:markets/src/models/field.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
// import '../models/category.dart';
import 'GridViewOfMainFieldItem.dart';

// ignore: must_be_immutable
class GridViewOfMainFields extends StatelessWidget {
  List<Field> fields=[];

  GridViewOfMainFields({Key key, this.fields}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(fields.length);
    return this.fields.isEmpty
        ? CircularLoadingWidget(height: 150)
        :  new StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: fields.length,
      itemBuilder: (BuildContext context, int index) {
        
        return GridViewOfMainFieldItem(field: fields.elementAt(index), );
      },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
            // child: ListView.builder(
            //   itemCount: this.categories.length,
            //   scrollDirection: Axis.horizontal,
            //   itemBuilder: (context, index) {
            //     double _marginLeft = 0;
            //     (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            //     return new CategoriesCarouselItemWidget(
            //       marginLeft: _marginLeft,
            //       category: this.categories.elementAt(index),
            //     );
            //   },
            // ));
          
}
}