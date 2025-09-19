import 'package:flutter/material.dart';

class SiswaFormProvider with ChangeNotifier {
  // Step 0
  String nisn = '';
  String namaLengkap = '';
  String? jenisKelamin;
  String? agamaNama;
  String tempatLahir = '';
  DateTime? tanggalLahir;
  String noHp = '';
  String nik = '';

  // Step 1
  String jalan = '';
  String rt = '';
  String rw = '';
  String? dusunNama;
  String? desaNama;
  String? kecamatanNama;
  String? kabupatenNama;
  String? provinsiNama;
  String? kodePosKode;

  // Step 2
  String namaAyah = '';
  String namaIbu = '';
  String? namaWali;
  String alamatOrtu = '';

  // IDs (akan diisi setelah autocomplete)
  int? idAgama;
  int? idDusun;
  int? idAlamat;
  int? idOrangTua;
  int? idWali;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool validateStep0() {
    return nisn.isNotEmpty &&
        namaLengkap.isNotEmpty &&
        jenisKelamin != null &&
        agamaNama != null &&
        tempatLahir.isNotEmpty &&
        tanggalLahir != null &&
        noHp.isNotEmpty &&
        nik.isNotEmpty;
  }

  bool validateStep1() {
    return jalan.isNotEmpty &&
        rt.isNotEmpty &&
        rw.isNotEmpty &&
        idDusun != null;
  }

  bool validateStep2() {
    return namaAyah.isNotEmpty && namaIbu.isNotEmpty && alamatOrtu.isNotEmpty;
  }

  void setAlamat({
    required String jalan,
    required String rt,
    required String rw,
    required int? idDusun,
    bool silent = false
  }) {
    this.jalan = jalan;
    this.rt = rt;
    this.rw = rw;
    this.idDusun = idDusun;
    if (!silent) notifyListeners();
  }
}
