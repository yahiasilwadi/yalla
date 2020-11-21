import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  final _phoneController = TextEditingController(text: '+962');

  String phoneNo, smsId, verificationId;

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

  messageDialog(BuildContext context, String type, String title,
      String content) {
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

  Future<void> verifyPhone() async {
    await FirebaseAuth.instance.signOut();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialoge(context).then((value) {
        print('Signed In');
      });
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print('verified');
    };
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        messageDialog(
            _con.scaffoldKey.currentContext,
            'error',
            'خطأ في رقم الهاتف',
            'رقم الهاتف الذي أدخلته غير صحيح\nيرجى كتابة رقم صحيح مع + ورمز الدولة');
      } else {
        print('-------------------error------------${e}');
        //Navigator.of(context).pop();
        messageDialog(_con.scaffoldKey.currentContext, 'error', 'حدث خطأ ما',
            'يبدوا انك تواجه مشكلة ما، يمكنك اعادة المحاولة لاحقا');
      }
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<bool> smsCodeDialoge(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('تأكيد رقم الهاتف'),
          /*content: TextField(
            onChanged: (value) {
              this.smsId = value;
            },
          ),*/
          content: TextFormField(
            onChanged: (value) {
              this.smsId = value;
            },
            decoration: InputDecoration(
              labelText: 'رمز التأكيد',
              labelStyle: TextStyle(color: Theme
                  .of(context)
                  .accentColor),
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.2))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.2))),
            ),
          ),
          contentPadding: EdgeInsets.all(16.0),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.of(context).pop();
                    print('================> Login success');
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dash()),
                      );*/

                  } else {
                    Navigator.of(context).pop();
                    signIn(smsId);
                  }
                },
                child: Text(
                  'تأكيد',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      //Navigator.of(context).pushReplacementNamed('/loginpage');
      print('-------------------user------------${user.user.phoneNumber}');
      _con.register();
    }).catchError((e) {
      if (e.code == 'invalid-verification-code') {
        //Navigator.of(context).pop();
        messageDialog(
            _con.scaffoldKey.currentContext,
            'error',
            'الرمز السري خاطئ',
            'يرجى اعادة المحاولة والتأكد من ادخال الرمز السري بشكل صحيح');
      } else {
        print('-------------------error------------${e}');
        //Navigator.of(context).pop();
        messageDialog(_con.scaffoldKey.currentContext, 'error', 'حدث خطأ ما',
            'يبدوا انك تواجه مشكلة ما، يمكنك اعادة المحاولة لاحقا');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: Helper
            .of(context)
            .onWillPop,
        child: Scaffold(
          key: _con.scaffoldKey,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    S
                        .of(context)
                        .lets_start_with_register,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline2
                        .merge(TextStyle(color: Theme
                        .of(context)
                        .accentColor)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 50,
                          color: Theme
                              .of(context)
                              .hintColor
                              .withOpacity(0.2),
                        )
                      ]),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                  width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                  child: Form(
                    key: _con.loginFormKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.name = input,
                          validator: (input) =>
                          input.length < 3
                              ? S
                              .of(context)
                              .should_be_more_than_3_letters
                              : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .full_name,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S
                                .of(context)
                                .john_doe,
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.person_outline,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) =>
                          !input.contains('@')
                              ? S
                              .of(context)
                              .should_be_a_valid_email
                              : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .email,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'johndoe@gmail.com',
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.alternate_email,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          obscureText: _con.hidePassword,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) =>
                          input.length < 6
                              ? S
                              .of(context)
                              .should_be_more_than_6_letters
                              : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .password,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: '••••••••••••',
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: Theme
                                  .of(context)
                                  .focusColor,
                              icon: Icon(_con.hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          onSaved: (input) => _con.user.phone = input,
                          onChanged: (input) => phoneNo = input,
                          textDirection: TextDirection.ltr,
                          controller: _phoneController,
                          //validator: (input) => input.length != 10 ? S.of(context).phone : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .phone,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: '+962787001398',
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.phone,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.address = input,
                          validator: (input) =>
                          input == null ? S
                              .of(context)
                              .address : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .address,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'حي السعادة (حارة 5)',
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.location_city,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.bio = input,
                          validator: (input) =>
                          input == null ? S
                              .of(context)
                              .about : null,
                          decoration: InputDecoration(
                            labelText: S
                                .of(context)
                                .about,
                            labelStyle:
                            TextStyle(color: Theme
                                .of(context)
                                .accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'شارع هاشم خير 37',
                            hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.account_balance,
                                color: Theme
                                    .of(context)
                                    .accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        BlockButtonWidget(
                          text: Text(
                            S
                                .of(context)
                                .register,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                          ),
                          color: Theme
                              .of(context)
                              .accentColor,
                          onPressed: verifyPhone,
                        ),
                        SizedBox(height: 25),
//                      FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Login');
                  },
                  textColor: Theme
                      .of(context)
                      .hintColor,
                  child: Text(S
                      .of(context)
                      .i_have_account_back_to_login),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
