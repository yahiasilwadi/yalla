import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../models/coupon.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  final Coupon coupon;
  const CartBottomDetailsWidget({
    Key key,
    this.coupon,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: MediaQuery.of(context).size.height / 3.5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.of(context).subtotal,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Helper.getPrice(_con.subTotal, context,
                            style: Theme.of(context).textTheme.subtitle1,
                            zeroPlaceholder: '0')
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.of(context).delivery_fee,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        if (Helper.canDelivery(_con.carts[0].product.market,
                            carts: _con.carts))
                          Helper.getPrice(
                              _con.carts[0].product.market.deliveryFee, context,
                              style: Theme.of(context).textTheme.subtitle1,
                              zeroPlaceholder: 'Free')
                        else
                          Helper.getPrice(0, context,
                              style: Theme.of(context).textTheme.subtitle1,
                              zeroPlaceholder: 'Free')
                      ],
                    ),
                    /*Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Helper.getPrice(_con.taxAmount, context,
                            style: Theme.of(context).textTheme.subtitle1)
                      ],
                    ),*/
                    // SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 2),
                                blurRadius: 5.0)
                          ]),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onSubmitted: (String value) {
                          _con.doApplyCoupon(value);
                        },
                        cursorColor: Theme.of(context).accentColor,
                        controller: TextEditingController()
                          ..text = coupon?.code ?? '',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                          suffixText: coupon?.valid == null
                              ? ''
                              : (coupon.valid
                                  ? S.of(context).validCouponCode
                                  : S.of(context).invalidCouponCode),
                          suffixStyle: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(
                                  TextStyle(color: _con.getCouponIconColor())),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.confirmation_number,
                              color: _con.getCouponIconColor(),
                              size: 28,
                            ),
                          ),
                          hintText: S.of(context).haveCouponCode,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                    Stack(
                      fit: StackFit.loose,
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              _con.goCheckout(context);
                            },
                            disabledColor:
                                Theme.of(context).focusColor.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: !_con.carts[0].product.market.closed
                                ? Theme.of(context).accentColor
                                : Theme.of(context).focusColor.withOpacity(0.5),
                            shape: StadiumBorder(),
                            child: Text(
                              S.of(context).checkout,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Helper.getPrice(_con.total, context,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              zeroPlaceholder: 'Free'),
                        )
                      ],
                    ),
                    //SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
  }
}
