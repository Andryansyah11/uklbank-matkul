import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ukl/services/url.dart' as url;
import 'dart:convert';

import 'package:ukl/widgets/navbar.dart';

class MatkulViewPage extends StatefulWidget {
  const MatkulViewPage({super.key});

  @override
  State<MatkulViewPage> createState() => _MatkulViewPageState();
}

class _MatkulViewPageState extends State<MatkulViewPage> {
  List<dynamic> matkulList = [];
  bool isLoading = true;
  String? error;
  List<bool> selected = [];

  Future<void> fetchMatkul() async {
    try {
      final response = await http.get(
        Uri.parse(url.BaseUrl + '/getmatkul'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          matkulList = data['data'];
          selected = List<bool>.filled(matkulList.length, false);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data mata kuliah");
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMatkul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6FF), // Sesuaikan warna dasar
      appBar: AppBar(
        title: const Text('Daftar Mata Kuliah'),
        backgroundColor: Colors.blue,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: matkulList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            var matkul = matkulList[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    matkul['id']?.toString() ?? "-",
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                                title: Text(matkul['nama_matkul'] ?? "Tidak diketahui"),
                                subtitle: Text("${matkul['sks'] ?? '-'} SKS"),
                                trailing: Checkbox(
                                  value: selected[index],
                                  activeColor: Colors.blue,
                                  onChanged: (val) {
                                    setState(() {
                                      selected[index] = val!;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
  List<Map<String, dynamic>> selectedMatkul = [];

  for (int i = 0; i < selected.length; i++) {
    if (selected[i]) {
      selectedMatkul.add({
        "id": matkulList[i]['id'],
        "nama_matkul": matkulList[i]['nama_matkul'],
        "sks": matkulList[i]['sks'],
      });
    }
  }

  final responseMap = {
    "status": true,
    "message": "Matkul selected successfully",
    "data": {
      "list_matkul": selectedMatkul,
    }
  };

  // Cetak ke terminal dengan format JSON
  print(const JsonEncoder.withIndent('  ').convert(responseMap));

  // Snackbar untuk konfirmasi di UI
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Mata kuliah disimpan")),
  );
},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Simpan yang Terpilih",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomNav(1),
    );
  }
}
