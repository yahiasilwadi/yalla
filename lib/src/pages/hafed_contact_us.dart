import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/hafed_contact_us_cont.dart';

class HafedContactUs extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HafedContactUs({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HafedContactUsState createState() => _HafedContactUsState();
}

class _HafedContactUsState extends StateMVC<HafedContactUs> {
  HCUController _con;

  _HafedContactUsState() : super(HCUController()) {
    _con = controller;
  }

  /*@override
  void initState() {
    _con.currentMarket = widget.routeArgument?.param as Market;
    if (_con.currentMarket?.latitude != null) {
      // user select a market
      _con.getMarketLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    }
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        title: Text(
          //S.of(context).maps_explorer,
          'إتصل بنا',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  MdiIcons.mail,
                  color: Theme.of(context).accentColor,
                  size: MediaQuery.of(context).size.width / 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text('اتصل بنا',
                      style: Theme.of(context).textTheme.headline1),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                    onTap: () async {
                      var PhoneNum = "tel:+962787001398";
                      await canLaunch(PhoneNum)
                          ? launch(PhoneNum)
                          : print("could not launch telephone");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    title: Text('Phone'),
                    subtitle: Text('+62787001398'),
                    leading: Card(
                      elevation: 0.0,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          MdiIcons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: ListTile(
                    onTap: () async {
                      var whatsappUrl = "whatsapp://send?phone=+962787001398";
                      await canLaunch(whatsappUrl)
                          ? launch(whatsappUrl)
                          : print("could not launch whatsapp");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    title: Text('whatsapp'),
                    subtitle: Text('+962787001398'),
                    leading: Card(
                      elevation: 0.0,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          MdiIcons.whatsapp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
