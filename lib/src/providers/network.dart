import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String url;
  final String endpoint;
  final Map<String, dynamic> parameters;
  final Map<String, String> headers;

  Network(
      {required this.url, required this.endpoint, required this.parameters, required this.headers});

  Future getData() async {
    final http.Response response =
        await http.get(Uri.https(url, endpoint, parameters), headers: headers);
    if (response.statusCode == 200) {
      final String data = response.body;
      final decodedData = jsonDecode(data);
      return decodedData;
    } else {
      return response.statusCode;
    }
  }
}
