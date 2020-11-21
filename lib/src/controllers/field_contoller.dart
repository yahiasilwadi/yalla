import 'package:markets/src/models/field.dart';
import 'package:markets/src/models/market.dart';
import 'package:markets/src/repository/field_repository.dart';
import 'package:markets/src/repository/market_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';



class FieldController extends ControllerMVC {
List<Field> fields = <Field>[];


    void listenForFields() async {
    final Stream<Field> stream = await getFields();
    await stream.listen((Field _field) {
     //print(_field.image);
      setState(() => fields.add(_field));
    
    }, onError: (a) {}, onDone: () {});
  
  }

  Future<void> refreshField() async {
    setState(() {
      fields = <Field>[];

    });
    await listenForFields();

  }
Market market;

   listenForMarketID({String id}) async {
     //print(id+'aaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    final Stream<Market> stream = await getMarketByID(id);
    
    stream.listen((Market _market) {
      setState(() => market = _market);
      print(_market.toMap());
      return market;
    }, onError: (a) {
      print(a);
      
    }, onDone: () {
      //return market;
     
    
    });
    
  }
}