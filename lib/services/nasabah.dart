import 'dart:convert';
import 'dart:typed_data';
import 'package:ukl/models/nasabahlogin.dart';
import 'package:ukl/models/response_data_map.dart';
import 'package:ukl/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  Future<ResponseDataMap> registerNasabah(
  Map<String, dynamic> data, {
  required Uint8List fileBytes,
  required String fileName,
}) async {
  var uri = Uri.parse(url.BaseUrl + "/register");
  var request = http.MultipartRequest("POST", uri);

  // Tambahkan field teks
  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  // Tambahkan file foto
  request.files.add(
    http.MultipartFile.fromBytes(
      'foto',
      fileBytes,
      filename: fileName,
    ),
  );

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonData = json.decode(responseBody);

    if (response.statusCode == 200 && jsonData["status"] == true) {
      return ResponseDataMap(
        status: true,
        message: jsonData["message"],
        data: jsonData["data"],
      );
    } else {
      String message = '';
      if (jsonData["message"] is Map) {
        for (String key in jsonData["message"].keys) {
          message += jsonData["message"][key][0].toString() + '\n';
        }
      } else {
        message = jsonData["message"];
      }

      return ResponseDataMap(status: false, message: message.trim());
    }
  } catch (e) {
    return ResponseDataMap(
      status: false,
      message: "Terjadi kesalahan: $e",
    );
  }
}

Future login(data) async {
  var uri = Uri.parse(url.BaseUrl + "/login");
  var response = await http.post(uri, body: data);

  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    if (body["status"] == true) {
      Nasabahlogin userLogin = Nasabahlogin(
        status: body["status"],
        message: body["message"],
        username: body["data"]["username"],
      );

      await userLogin.prefs();
      return ResponseDataMap(
        status: true,
        message: "Sukses login",
        data: body,
      );
    } else {
      return ResponseDataMap(
        status: false,
        message: 'Username dan password salah',
      );
    }
  } else if (response.statusCode == 422) {
    // Menangani error validasi Laravel
    String message = '';
    if (body["message"] is Map) {
      for (var key in body["message"].keys) {
        message += '${body["message"][key][0]}\n';
      }
    } else {
      message = body["message"].toString();
    }

    return ResponseDataMap(
      status: false,
      message: message.trim(),
    );
  } else {
    return ResponseDataMap(
      status: false,
      message: "Gagal login. Code error: ${response.statusCode}",
    );
  }
}

}