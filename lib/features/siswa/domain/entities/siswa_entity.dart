class SiswaEntity {
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

  SiswaEntity({
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
}