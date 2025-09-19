import 'package:project_4/features/siswa/data/models/dusun_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

abstract class SiswaRepository {
  // Future<List<DusunItemModel>> getSuggestions(String query);
  Future<int?> getAgamaId(String nama);
  Future<Map<String, dynamic>?> getAlamatSiswa(int idAlamat);
  Future<int?> insertAlamat({
    required String jalan,
    required int rt,
    required int rw,
    required int idDusun,
  });
  Future<int?> insertOrangTua({
    required String namaAyah,
    required String namaIbu,
    int? idAlamat,
  });
  Future<int?> insertWali({required String namaWali, int? idAlamat});
  Future<void> insertSiswa(Map<String, dynamic> data);
  Future<void> updateSiswa(int id, Map<String, dynamic> data);
  Future<void> deleteSiswa(int id);
  Future<List<Map<String, dynamic>>> getSiswa() async {
    final res = await client
        .from('v_siswa_full')
        .select()
        .order('created_at', ascending: false);
    return res;
  }

  Future<List<DusunItemModel>> getDusunSuggestions(String query);
  Future<Map<String, dynamic>?> getDusunDetails(String namaDusun);
}
