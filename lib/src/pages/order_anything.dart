import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class OrderAnything extends StatefulWidget {
  @override
  _OrderAnythingState createState() => _OrderAnythingState();
}

class _OrderAnythingState extends State<OrderAnything> {
  TextEditingController market_name = new TextEditingController();
  TextEditingController market_address = new TextEditingController();
  TextEditingController user_address = new TextEditingController();
  TextEditingController products = new TextEditingController();

  String user_info = currentUser.value.apiToken == null
      ? ''
      : '${currentUser.value.id}:${currentUser.value.name}:${currentUser.value.phone}:${currentUser.value.email}';

  progressDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 7, right: 7),
            child: Text('إنتظر قليلا'),
          )
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
  }

  messageDialog(
      BuildContext context, String type, String title, String content) {
    Widget okButton = FlatButton(
        child: Text('حسنا'),
        onPressed: () {
          Navigator.of(context).pop();
          if (type == 'success') {
            Navigator.of(context).pop();
          }
        });
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [okButton],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
  }

  Future<String> addOrderAnyThings() async {
    progressDialog(context);
    try {
      var map = Map<String, dynamic>();
      map['market_name'] = market_name.text;
      map['market_address'] = market_address.text;
      map['user_address'] = user_address.text;
      map['user_info'] = user_info;
      map['products'] = products.text;
      final response = await http.post(
          'https://laravel.yalla-abunsair.com/order_any_things/add_order.php',
          body: map);
      print('addNotify Response: ${response.body}');
      Navigator.pop(context);
      if (200 == response.statusCode) {
        messageDialog(context, 'success', 'تم الارسال',
            'لقد تم ارسال طلبك وسوف نتصل بك في اقرب وقت');
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'أطلب أي شيئ',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Card(
                      elevation: 0.0,
                      color: Colors.red[200],
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'سعر هذه الخدمة 1 دينار فقط داخل مدينة أبو نصير',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 4,
                        autoPlay: true),
                    items: [
                      'https://laravel.yalla-abunsair.com/order_any_things/image_slider/1.jpg',
                      'https://laravel.yalla-abunsair.com/order_any_things/image_slider/2.jpg',
                      'https://laravel.yalla-abunsair.com/order_any_things/image_slider/3.jpg',
                      'https://laravel.yalla-abunsair.com/order_any_things/image_slider/4.jpg',
                      'https://laravel.yalla-abunsair.com/order_any_things/image_slider/5.jpg'
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(16.0),
                                image: DecorationImage(
                                    image: NetworkImage('$i'),
                                    fit: BoxFit.fill)),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'معلومات المتجر',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: market_name,
                    decoration: InputDecoration(
                      labelText: 'اسم المتجر',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'متجر اني ثينغ',
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.store,
                          color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: market_address,
                    readOnly: true,
                    onTap: () async {
                      LocationResult result = await showLocationPicker(
                        context,
                        setting.value.googleMapsKey,
                        initialCenter: LatLng(
                            deliveryAddress.value?.latitude ?? 0,
                            deliveryAddress.value?.longitude ?? 0),
                        automaticallyAnimateToCurrentLocation: true,
                        myLocationButtonEnabled: true,
                      );
                      addAddress(new Address.fromJSON({
                        'address': result.address,
                        'latitude': result.latLng.latitude,
                        'longitude': result.latLng.longitude,
                      }));
                      print("result = $result");
                      setState(() {
                        market_address.text =
                            '${result.address} (${result.latLng.latitude}-${result.latLng.longitude})';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'موقع المتجر',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'شارع رقم 5، الاردن',
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.location_on,
                          color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: user_address,
                    readOnly: true,
                    onTap: () async {
                      LocationResult result = await showLocationPicker(
                        context,
                        setting.value.googleMapsKey,
                        initialCenter: LatLng(
                            deliveryAddress.value?.latitude ?? 0,
                            deliveryAddress.value?.longitude ?? 0),
                        automaticallyAnimateToCurrentLocation: true,
                        myLocationButtonEnabled: true,
                      );
                      addAddress(new Address.fromJSON({
                        'address': result.address,
                        'latitude': result.latLng.latitude,
                        'longitude': result.latLng.longitude,
                      }));
                      print("result = $result");
                      setState(() {
                        user_address.text =
                            '${result.address} (${result.latLng.latitude}-${result.latLng.longitude})';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'موقعك',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'حي الورود، شارع 2، عمان',
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.location_on,
                          color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'أخبرنا ماذا نشتري؟',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    'افصل بين المنتجات بفاصلة (،)',
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: products,
                    maxLines: null,
                    minLines: 3,
                    decoration: InputDecoration(
                      labelText: 'المنتجات',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12),
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.add_shopping_cart,
                          color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.2))),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (currentUser.value.apiToken == null) {
                        Navigator.of(context).pushNamed('/Login');
                      } else {
                        if (market_name.text.trim().isEmpty ||
                            market_address.text.trim().isEmpty ||
                            user_address.text.trim().isEmpty ||
                            products.text.trim().isEmpty ||
                            market_name.text == null ||
                            market_address.text == null ||
                            user_address.text == null ||
                            products.text == null) {
                          messageDialog(context, 'error', 'خطأ',
                              'يرجى ملئ جميع المعلومات واعادة المحاولة لاحقا');
                        } else {
                          addOrderAnyThings();
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: Text('إرسال'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
