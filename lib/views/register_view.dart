import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ukl/widgets/alert.dart';
import 'package:ukl/services/nasabah.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();
  final UserService user = UserService();

  TextEditingController nama_nasabah = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telepon = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController foto = TextEditingController();

  List<String> genderOptions = ["Laki-laki", "Perempuan"];
  String? selectedGender;

  Uint8List? imageBytes;
  String? imageName;

  Future<void> pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          imageBytes = result.files.single.bytes!;
          imageName = result.files.single.name;
          foto.text = imageName!;
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        setState(() {
          imageBytes = file.readAsBytesSync();
          imageName = pickedFile.name;
          foto.text = imageName!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Register Nasabah"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            width: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    'images/1.png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Form Register Nasabah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField("Nama Nasabah", nama_nasabah),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    items: genderOptions.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedGender = value),
                    validator: (value) =>
                        value == null ? 'Gender harus dipilih' : null,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField("Alamat", alamat),
                  const SizedBox(height: 10),
                  _buildInputField("Telepon", telepon, type: TextInputType.phone),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Upload Foto",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: Icon(Icons.upload),
                        label: const Text("Pilih Gambar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          imageName ?? "Belum ada file",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildInputField("Username", username),
                  const SizedBox(height: 10),
                  _buildInputField("Password", password, isPassword: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _handleSubmit,
                      child: const Text("REGISTER"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(color: Colors.green),
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

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      validator: (value) => value!.isEmpty ? '$label harus diisi' : null,
    );
  }

  void _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      var data = {
        "nama_nasabah": nama_nasabah.text,
        "gender": selectedGender,
        "alamat": alamat.text,
        "telepon": telepon.text,
        "username": username.text,
        "password": password.text,
        "foto": foto.text, // hanya nama file, bukan file-nya
      };

      var result = await user.registerNasabah(data, fileBytes: imageBytes!, fileName: imageName!); // jika kamu pakai multipart
      if (result.status == true) {
        nama_nasabah.clear();
        alamat.clear();
        telepon.clear();
        username.clear();
        password.clear();
        foto.clear();
        setState(() {
          selectedGender = null;
          imageBytes = null;
          imageName = null;
        });
        AlertMessage().showAlert(context, result.message, true);
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }
}
