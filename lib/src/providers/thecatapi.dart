import 'package:thecatapi/src/models/export.dart';
import 'package:thecatapi/src/providers/export.dart';

class TheCatAPI {

  final String url = 'api.thecatapi.com';
  final String endpoint = '/v1/images/search';
  late Map<String, dynamic> parameters;
  final Map<String, String> headers = {'x-api-key': '126ff0e1-e6a7-4788-80a6-b1703e8b4e0a' }; // as the cat api isnt a sensitive api, storing the api key in the code base although isnt secure, isnt a great security risk

  late Network connection;

  List<Cat> cats = [];

  Future<List<Cat>?> getData({required int pageNumber}) async {
    parameters = { 'page': pageNumber.toString(), 'limit': "25"  };
    connection = Network(url: url, endpoint: endpoint, parameters: parameters, headers: headers);
    final result = await connection.getData();
    if (result.runtimeType == int){
      return null;
    } else {
      result.forEach((element){
        final String imageUrl = element["url"];
        final Cat cat = Cat(url: imageUrl);
        cats.add(cat);
      });
      return cats;
    }

  }
  
}
