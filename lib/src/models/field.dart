import 'package:markets/src/models/market.dart';

import '../models/media.dart';

class Field {
  String id;
  String name;
  String description;
  Media image;
  List<dynamic> marketsListOfMaps =[];
  List<Market> markets = [];
  bool selected;

  Field();
  //Media m = new Media;


  Field.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      description = jsonMap['description'];
      description = description.replaceAll('<p>', "");
      description = description.replaceAll('</p>', "");
      description = description.replaceAll('<br>', "");
      
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    //  print(image.url+'^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6');
      marketsListOfMaps = jsonMap['markets'];
      for(int i =0 ; i<marketsListOfMaps.length; i++){
       // marketsMap.map((key, value) => null)
       markets.add(Market.fromJSON(marketsListOfMaps[i]));
       //print(marketsListOfMaps[i]);
      }
      selected = jsonMap['selected'] ?? false;
    } catch (e) {
      id = '';
      name = '';
      description = '';
      image = new Media();
      selected = false;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
