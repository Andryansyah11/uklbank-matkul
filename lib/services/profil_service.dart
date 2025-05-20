import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukl/services/url.dart' as url;
import 'package:ukl/models/profil.dart';

class ProfilService {
  Future<Profil?> getProfil() async {
    var res = await http.get(Uri.parse(url.BaseUrl + '/profil'));
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      if (jsonData['status'] == true) {
        return Profil.fromJson(jsonData['data']);
      }
    }
    return null;
  }

  Future<bool> updateProfil(Map<String, String> data) async {
  var res = await http.put(
    Uri.parse(url.BaseUrl + '/update/1'),
    body: data,
  );

  print("Response body: ${res.body}");

  if (res.statusCode == 200) {
    var jsonData = json.decode(res.body);
    return jsonData['status'] == true;
  }
  return false;
}

}
