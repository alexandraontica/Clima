import 'dart:convert';
import 'package:http/http.dart' as http;

class Networking {
  Networking(this.urlString);

  final String urlString;

  Future getData() async {
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      return response.statusCode;
    }
  }

  Future postRequest(dynamic body) async {
    Uri url = Uri.parse(urlString);

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    body = jsonEncode(body);

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    try {
      return jsonDecode(response.body);
    } catch(e) {
      return response.statusCode;
    }
  }
}
