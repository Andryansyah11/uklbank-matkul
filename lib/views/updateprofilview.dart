import 'package:flutter/material.dart';
import 'package:ukl/services/profil_service.dart';
import 'package:ukl/models/profil.dart';

class UpdateProfilView extends StatefulWidget {
  const UpdateProfilView({super.key});

  @override
  State<UpdateProfilView> createState() => _UpdateProfilViewState();
}

class _UpdateProfilViewState extends State<UpdateProfilView> {
  final formKey = GlobalKey<FormState>();
  final ProfilService profilService = ProfilService();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  String selectedGender = 'Laki-laki';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfil();
  }

  Future<void> loadProfil() async {
    var profil = await profilService.getProfil();
    if (profil != null) {
      setState(() {
        namaController.text = profil.namaPelanggan;
        alamatController.text = profil.alamat;
        teleponController.text = profil.telepon;
        selectedGender = profil.gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0FF),
      appBar: AppBar(
        title: const Text("Update Profil"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/dashboard');
            },
        )],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pelanggan',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Laki-laki', 'Perempuan']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: teleponController,
                    decoration: InputDecoration(
                      labelText: 'Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                var data = {
                                  "nama_pelanggan": namaController.text,
                                  "alamat": alamatController.text,
                                  "gender": selectedGender,
                                  "telepon": teleponController.text,
                                };

                                bool result = await profilService.updateProfil(data);

                                setState(() {
                                  isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result
                                        ? "Berhasil update profil"
                                        : "Gagal update profil"),
                                    backgroundColor:
                                        result ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "UPDATE PROFIL",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
