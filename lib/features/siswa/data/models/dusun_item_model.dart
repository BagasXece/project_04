class DusunItemModel {
  final int idDusun;
  final String namaDusun;
  final String namaDesa;
  final String namaKecamatan;
  final String namaKabupaten;
  final String namaProvinsi;
  final String kodePos;

  DusunItemModel.fromMap(Map<String, dynamic> m)
      : idDusun = m['id_dusun'] as int,
        namaDusun = m['nama_dusun'],
        namaDesa = m['nama_desa'],
        namaKecamatan = m['nama_kecamatan'],
        namaKabupaten = m['nama_kabupaten'],
        namaProvinsi = m['nama_provinsi'],
        kodePos = m['kode_pos'];

  /// Teks yang ditampilkan di autocomplete
  String get display => '$namaDusun • $namaDesa';
}