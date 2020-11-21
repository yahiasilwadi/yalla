import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }
  var location = new Location();
  @override
  void initState() {
    _con.doApplyCoupon(coupon.code);
    location.requestService().then((value) {
      location.getLocation();
      print(location.getLocation());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      //bottomNavigationBar: CartBottomDetailsWidget(con: _con),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.map,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).delivery,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: _con.carts.isNotEmpty &&
                      Helper.canDelivery(_con.carts[0].product.market,
                          carts: _con.carts)
                  ? Text(
                      S
                          .of(context)
                          .click_to_confirm_your_address_and_pay_or_long_press,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    )
                  : Text(
                      S.of(context).deliveryMethodNotAllowed,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Card(
                    elevation: 0.0,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    child: ListTile(
                      onTap: () {
                        modal(context);
                      },
                      title: Text('قم بإضافة موقعك'),
                      subtitle: Text(
                          'اضغط هنا لاختيار الموقع او اختيار موقعك الحالي'),
                      leading: Icon(
                        MdiIcons.handPointingUp,
                        size: 48.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  _con.carts.isNotEmpty &&
                          Helper.canDelivery(_con.carts[0].product.market,
                              carts: _con.carts)
                      ? DeliveryAddressesItemWidget(
                          paymentMethod: _con.getDeliveryMethod(),
                          address: _con.deliveryAddress,
                          onPressed: (Address _address) {
                            if (_con.deliveryAddress.id == null ||
                                _con.deliveryAddress.id == 'null') {
                              DeliveryAddressDialog(
                                context: context,
                                address: _address,
                                onChanged: (Address _address) {
                                  _con.addAddress(_address);
                                  _con.toggleDelivery();
                                },
                              );
                            } else {
                              _con.toggleDelivery();
                            }
                          },
                          onLongPress: (Address _address) {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.updateAddress(_address);
                                _con.toggleDelivery();
                              },
                            );
                          },
                        )
                      : NotDeliverableAddressesItemWidget(),
                  _con.deliveryAddress.id != null ||
                          _con.deliveryAddress.id != 'null'
                      ? Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          child: ListTile(
                            title: Text('* اضغط على الموقع لاختياره'),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          CartBottomDetailsWidget(
            con: _con,
            coupon: coupon,
          ),
        ],
      ),
    );
  }

  modal(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            //height: 200,
            //color: Colors.amber,
            child: DeliveryAddressBottomSheetWidget(
              scaffoldKey: _con.scaffoldKey,
            ),
          );
        });
  }
}
