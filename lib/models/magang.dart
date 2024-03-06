class MagangModel {
  final int? id;
  final String nama;
  final String posisi;
  final String gaji;
  final String foto;

  const MagangModel(
      {this.id,
      required this.nama,
      required this.posisi,
      required this.gaji,
      required this.foto});
  Map<String, dynamic> toList() {
    return {
      'id': id,
      'nama' : nama,
      'posisi' : posisi,
      'gaji' : gaji,
      'foto' : foto
    };
  }

  @override
  String toString() {
    return "{id: $id, nama: $nama, posisi: $posisi, gaji: $gaji, foto: $foto}";
  }
}
