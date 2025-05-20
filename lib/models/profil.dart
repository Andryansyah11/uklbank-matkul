class Profil {
  final String id;
  final String namaPelanggan;
  final String alamat;
  final String gender;
  final String telepon;

  Profil({
    required this.id,
    required this.namaPelanggan,
    required this.alamat,
    required this.gender,
    required this.telepon,
  });

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      id: json['id'].toString(),
      namaPelanggan: json['nama_pelanggan'],
      alamat: json['alamat'],
      gender: json['gender'],
      telepon: json['telepon'],
    );
  }
}
