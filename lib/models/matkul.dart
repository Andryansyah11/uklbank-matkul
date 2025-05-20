class Matkul {
  final int id;
  final String namaMatkul;
  final int sks;

  Matkul({required this.id, required this.namaMatkul, required this.sks});

  factory Matkul.fromJson(Map<String, dynamic> json) {
    return Matkul(
      id: json['id'],
      namaMatkul: json['nama_matkul'],
      sks: json['sks'],
    );
  }
}
