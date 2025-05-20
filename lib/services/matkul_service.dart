import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/url.dart' as url;
import '../models/matkul.dart';

class MatkulService {
  Future<List<Matkul>> getMatkul() async {
    final response = await http.get(
      Uri.parse(url.BaseUrl + '/getmatkul'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> list = data['data']; // pastikan 'data' sesuai respon
      return list.map((item) => Matkul.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data mata kuliah');
    }
  }
}
