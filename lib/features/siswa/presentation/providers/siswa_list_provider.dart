import 'package:flutter/material.dart';
import 'package:project_4/core/errors/exceptions.dart';
import 'package:project_4/core/utils/toast.dart';
import '../../../siswa/data/models/siswa_model.dart';
import '../../../siswa/domain/repositories/siswa_repository.dart';

class SiswaListProvider with ChangeNotifier {
  final SiswaRepository repository;

  SiswaListProvider({required this.repository});

  List<SiswaModel> _siswaList = [];
  List<SiswaModel> get siswaList => _siswaList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSiswa() async {
    await WidgetsBinding.instance.endOfFrame;
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getSiswa();
      _siswaList = data.map((e) => SiswaModel.fromMap(e)).toList();
    } on NoInternetException {
      // ➜ tambahkan
      _siswaList = [];
      Toast.error('Tidak ada koneksi internet');
    } on ServerException catch (e) {
      // ➜ sudah ada
      _siswaList = [];
      Toast.error(e.message);
    } catch (e) {
      _siswaList = [];
      Toast.error('Terjadi kesalahan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSiswa(int id) async {
    try {
      await repository.deleteSiswa(id);
      Toast.success('Data dihapus');
      await loadSiswa();
    } on NoInternetException {
      Toast.error('Tidak ada koneksi internet');
    } on ServerException catch (e) {
      Toast.error(e.message);
    } catch (e) {
      Toast.error('Gagal menghapus: $e');
    }
  }
}
