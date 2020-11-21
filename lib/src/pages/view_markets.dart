import 'package:flutter/material.dart';
import '../controllers/field_contoller.dart';
import 'package:markets/src/controllers/market_controller.dart';
import 'package:markets/src/models/field.dart';
import 'package:markets/src/models/market.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
//import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class ViewMarketsByField extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
RouteArgument routeArgument;
  ViewMarketsByField({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<ViewMarketsByField> {
  FieldController _con;
  MarketController _marketController = MarketController();

 

  _HomeWidgetState() : super(FieldController()) {
    _con = controller;
    
  }
  //MarketController market;
 // MarketController marketController ;
  
//   getMarketsListOfThisField(){
//     Field field ;
//     for(int i = 0 ; i <   _con.fields.length ; i++){
//       print(widget.routeArgument.param.toString() + '<<<<<<<<<<<<<<<<<<<<<<');
// print(_con.fields[i].id);
//       if(_con.fields[i].id == widget.routeArgument.param){
//         field = _con.fields[i];
//       }
//     }

//     for(int z = 0 ; z< field.markets.length; z++){
//       print(field.markets[z].name + '!!!!!!!!!!!');
//     }

//     return field;



//   }
  
@override
void initState() { 
  _con.listenForFields();
  //getFullMarketsDetails();
  
    super.initState();

  //marketController.listenForMarkets();
  
  }
  getFullMarketParameters()async{

    List<Market> markets = [];
    print('herer');
    markets =await _marketController.listenForMarkets();
    // = _marketController.marketList;
    print(markets.length.toString()+'this is market lenrgth');


  }

  List<Market> mm = [];
 getFullMarketsDetails()async{
for(int x = 0 ; x < widget.routeArgument.param.markets.length;x++){
 Market market = await _con.listenForMarketID(id:widget.routeArgument.param.markets[x].id);
 //print(market.toMap());
//  mm.add(market);
}
//return mm;
 }
  @override
  Widget build(BuildContext context) {
   // print(marketController.markets);
   // Field ff = getMarketsListOfThisField();
    Field field = widget.routeArgument.param;
    var categoryId = widget.routeArgument.id;
    print(field.markets.length);
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshField,
        child: Container(

          //  scrollDirection: Axis.vertical,
            child: //Text(''),

              CardsCarouselWidget(marketsList:  field.markets,heroTag: 'home_top_markets',),
                //    SliverGrid(
           
                //      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //       childAspectRatio: 1.5,
                //     ),

                //     delegate: SliverChildBuilderDelegate(
                //       (context, index) => 
                //       CategoriesCarouselWidget( categories: _con.categories)
                //     ),
                // //      physics:ScrollPhysics() ,
                // //   itemCount: 10,
                // //   shrinkWrap:true,
                // //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                // //   itemBuilder: (context,index){
                // //     print('grid grid');
                // //     return(Padding(padding: EdgeInsets.all(8),
                // //     child: 
                // //     Container(width: 100,height: 100, color: Colors.blueAccent,),));
                // //  //   return Container(width: 200,height: 200,color: Colors.red,);
                // //   }),

                //  // Text('kjbkbkbkj')
                //    ),
              
            ),
          
         // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        //  child: Column(
        //    children: 
         
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   mainAxisSize: MainAxisSize.max,
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: SearchBarWidget(
          //         onClickFilter: (event) {
          //           widget.parentScaffoldKey.currentState.openEndDrawer();
          //         },
          //       ),
          //     ),

              // GridView.extent(maxCrossAxisExtent: 4,
              // children: [Container(width: 200,height:200,color: Colors.red,)],
              // )

              // GridView.builder(
              //   shrinkWrap: true,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
              //   itemBuilder: (context,index){
              //     return Container(width: 100,height: 100,color: Colors.red,);
              //   }),
              // Padding(
              //   padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //     leading: Icon(
              //       Icons.stars,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     trailing: IconButton(
              //       onPressed: () {
              //         if (currentUser.value.apiToken == null) {
              //           _con.requestForCurrentLocation(context);
              //         } else {
              //           var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
              //             (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              //             ),
              //           );
              //           bottomSheetController.closed.then((value) {
              //             _con.refreshHome();
              //           });
              //         }
              //       },
              //       icon: Icon(
              //         Icons.my_location,
              //         color: Theme.of(context).hintColor,
              //       ),
              //     ),
              //     title: Text(
              //       S.of(context).top_markets,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //     subtitle: Text(
              //       S.of(context).near_to + " " + (settingsRepo.deliveryAddress.value?.address ?? S.of(context).unknown),
              //       style: Theme.of(context).textTheme.caption,
              //     ),
              //   ),
              // ),
              // CardsCarouselWidget(marketsList: _con.topMarkets, heroTag: 'home_top_markets'),
              // ListTile(
              //   dense: true,
              //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
              //   leading: Icon(
              //     Icons.trending_up,
              //     color: Theme.of(context).hintColor,
              //   ),
              //   title: Text(
              //     S.of(context).trending_this_week,
              //     style: Theme.of(context).textTheme.headline4,
              //   ),
              //   subtitle: Text(
              //     S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
              //     maxLines: 2,
              //     style: Theme.of(context).textTheme.caption,
              //   ),
              // ),
              // ProductsCarouselWidget(productsList: _con.trendingProducts, heroTag: 'home_product_carousel'),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //     leading: Icon(
              //       Icons.category,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).product_categories,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //   ),
              // ),
              // CategoriesCarouselWidget(
              //   categories: _con.categories,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //     leading: Icon(
              //       Icons.trending_up,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).most_popular,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: GridWidget(
              //     marketsList: _con.popularMarkets,
              //     heroTag: 'home_markets',
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ListTile(
              //     dense: true,
              //     contentPadding: EdgeInsets.symmetric(vertical: 20),
              //     leading: Icon(
              //       Icons.recent_actors,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).recent_reviews,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ReviewsListWidget(reviewsList: _con.recentReviews),
              //),
            
          
        
      ),
    );
  }
}
