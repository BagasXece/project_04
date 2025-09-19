import 'package:flutter/material.dart';
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
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getSiswa(); // Tambahkan method ini di repo
      _siswaList = data.map((e) => SiswaModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Error loading siswa: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSiswa(int id) async {
    try {
      await repository.deleteSiswa(id);
      await loadSiswa();
    } catch (e) {
      debugPrint('Error deleting siswa: $e');
    }
  }
}