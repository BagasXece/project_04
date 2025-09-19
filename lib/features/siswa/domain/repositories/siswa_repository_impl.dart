import 'package:project_4/features/siswa/data/models/dusun_item_model.dart';

import '../../data/datasources/siswa_remote_datasource.dart';
import '../repositories/siswa_repository.dart';

class SiswaRepositoryImpl implements SiswaRepository {
  final SiswaRemoteDataSource _remoteDataSource;

  SiswaRepositoryImpl(this._remoteDataSource);

  // @override
  // Future<List<DusunItemModel>> getSuggestions(String query) {
  //   return _remoteDataSource.getDusunSuggestions(query);
  // }

  @override
  Future<int?> getAgamaId(String nama) {
    return _remoteDataSource.getAgamaId(nama);
  }

  @override
  Future<Map<String, dynamic>?> getAlamatSiswa(int idAlamat) =>
      _remoteDataSource.getAlamatSiswa(idAlamat);

  @override
  Future<int?> insertAlamat({
    required String jalan,
    required int rt,
    required int rw,
    required int idDusun,
  }) {
    return _remoteDataSource.insertAlamat(
      jalan: jalan,
      rt: rt,
      rw: rw,
      idDusun: idDusun,
    );
  }

  @override
  Future<int?> insertOrangTua({
    required String namaAyah,
    required String namaIbu,
    int? idAlamat,
  }) {
    return _remoteDataSource.insertOrangTua(
      namaAyah: namaAyah,
      namaIbu: namaIbu,
      idAlamat: idAlamat,
    );
  }

  @override
  Future<int?> insertWali({required String namaWali, int? idAlamat}) =>
      _remoteDataSource.insertWali(namaWali: namaWali, idAlamat: idAlamat);

  @override
  Future<void> insertSiswa(Map<String, dynamic> data) {
    return _remoteDataSource.insertSiswa(data);
  }

  @override
  Future<void> updateSiswa(int id, Map<String, dynamic> data) {
    return _remoteDataSource.updateSiswa(id, data);
  }

  @override
  Future<void> deleteSiswa(int id) {
    return _remoteDataSource.deleteSiswa(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getSiswa() => _remoteDataSource.getSiswa();

  @override
  Future<List<DusunItemModel>> getDusunSuggestions(String query) =>
      _remoteDataSource.getDusunSuggestions(query);

  @override
  Future<Map<String, dynamic>?> getDusunDetails(String namaDusun) =>
      _remoteDataSource.getDusunDetails(namaDusun);
}
