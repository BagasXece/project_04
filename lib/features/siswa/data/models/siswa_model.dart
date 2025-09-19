class SiswaModel {
  final int? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final int idAgama;
  final String namaAgama;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String noHp;
  final String nik;
  final int? idAlamat;
  final String jalanAlamat;
  final int rtAlamat;
  final int rwAlamat;
  final int? idDusun;
  final String namaDusun;
  final String namaDesa;
  final String namaKecamatan;
  final String namaProvinsi;
  final String namaKabupaten;
  final String kodePos;
  final int? idOrangTua;
  final int? idWali;
  final String namaAyah;
  final String namaIbu;
  final String? namaWali;
  final String? alamatOrtu;

  SiswaModel({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.idAgama,
    required this.namaAgama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noHp,
    required this.nik,
    this.idAlamat,
    this.idDusun,
    required this.jalanAlamat,
    required this.rtAlamat,
    required this.rwAlamat,
    required this.namaDusun,
    required this.namaDesa,
    required this.namaKabupaten,
    required this.namaKecamatan,
    required this.namaProvinsi,
    required this.kodePos,
    this.idOrangTua,
    this.idWali,
    required this.namaAyah,
    required this.namaIbu,
    this.namaWali,
    this.alamatOrtu,
  });

  factory SiswaModel.fromMap(Map<String, dynamic> map) => SiswaModel(
    id: map['id'] as int?,
    nisn: map['nisn'] ?? '', // <-- anti null
    namaLengkap: map['nama_lengkap'] ?? '',
    jenisKelamin: map['jenis_kelamin'] ?? '',
    idAgama: map['id_agama'] as int,
    namaAgama: map['agama_nama'] ?? '',
    tempatLahir: map['tempat_lahir'] ?? '',
    tanggalLahir: DateTime.parse(map['tanggal_lahir'] ?? DateTime.now().toIso8601String()),
    noHp: map['no_hp'] ?? '',
    nik: map['nik'] ?? '',
    idAlamat: map['id_alamat'] as int?,
    idDusun: map['id_dusun'] as int?,
    jalanAlamat: map['jalan_alamat'] ?? '',
    rtAlamat: map['rt_alamat'] as int,
    rwAlamat: map['rw_alamat'] as int,
    namaDusun: map['nama_dusun'] ?? '',
    namaDesa: map['nama_desa'] ?? '',
    namaKecamatan: map['nama_kecamatan'] ?? '',
    namaKabupaten: map['nama_kabupaten'] ?? '',
    namaProvinsi: map['nama_provinsi'] ?? '',
    kodePos: map['kode_pos'] ?? '',
    idOrangTua: map['id_orang_tua'] as int?,
    idWali: map['id_wali'] as int?,
    namaAyah: map['nama_ayah'] ?? '',
    namaIbu: map['nama_ibu'] ?? '',
    namaWali: map['nama_wali'],
    alamatOrtu: map['alamat_ortu'],
  );

  Map<String, dynamic> toMap() => {
    'nisn': nisn,
    'nama_lengkap': namaLengkap,
    'jenis_kelamin': jenisKelamin,
    'id_agama': idAgama,
    'tempat_lahir': tempatLahir,
    'tanggal_lahir': tanggalLahir.toIso8601String(),
    'no_hp': noHp,
    'nik': nik,
    'id_alamat': idAlamat,
    'id_orang_tua': idOrangTua,
    'id_wali': idWali,
  };
}
