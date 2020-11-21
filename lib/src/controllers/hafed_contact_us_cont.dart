import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HCUController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  HCUController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
}
