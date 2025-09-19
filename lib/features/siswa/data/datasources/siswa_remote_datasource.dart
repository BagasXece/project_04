import 'package:project_4/features/siswa/data/models/dusun_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

/// Remote-data-source semua operasi CRUD yang menyangkut tabel
/// siswa, alamat, orang_tua, wali, agama, dusun, desa, kecamatan,
/// kabupaten, provinsi, kode_pos serta view v_siswa_full & search_dusun_full.
class SiswaRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  /* ----------------------------------------------------------
   *  AREA SISWA
   * ---------------------------------------------------------- */
  Future<List<Map<String, dynamic>>> getSiswa() async {
    try {
      final res = await _client
          .from('v_siswa_full')
          .select()
          .order('created_at', ascending: false);
      return res;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getAlamatSiswa(int idAlamat) async {
    try {
      return await _client
          .from('v_siswa_full')
          .select()
          .eq('id_alamat', idAlamat)
          .maybeSingle();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<void> insertSiswa(Map<String, dynamic> data) async {
    try {
      await _client.from('siswa').insert(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> updateSiswa(int id, Map<String, dynamic> data) async {
    try {
      await _client.from('siswa').update(data).eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteSiswa(int id) async {
    try {
      await _client.from('siswa').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /* ----------------------------------------------------------
   *  AREA ALAMAT
   * ---------------------------------------------------------- */
  Future<int?> insertAlamat({
    required String jalan,
    required int rt,
    required int rw,
    required int idDusun,
  }) async {
    // 1. Coba insert langsung
    try {
      final res = await _client
          .from('alamat')
          .insert({
            'jalan_alamat': jalan,
            'rt_alamat': rt,
            'rw_alamat': rw,
            'id_dusun': idDusun,
          })
          .select('id')
          .maybeSingle();
      return res?['id'] as int?;
    } on PostgrestException catch (e) {
      // 2. Kalau unique violation → ambil id yang sudah ada
      if (e.code == '23505') {
        // unique_violation
        final existing = await _client
            .from('alamat')
            .select('id')
            .eq('jalan_alamat', jalan)
            .eq('rt_alamat', rt)
            .eq('rw_alamat', rw)
            .eq('id_dusun', idDusun)
            .maybeSingle();
        return existing?['id'] as int?;
      }
      rethrow;
    }
  }

  /* ----------------------------------------------------------
   *  AREA ORANG TUA
   * ---------------------------------------------------------- */
  Future<int?> insertOrangTua({
    required String namaAyah,
    required String namaIbu,
    int? idAlamat,
  }) async {
    try {
      final res = await _client
          .from('orang_tua')
          .insert({
            'nama_ayah': namaAyah,
            'nama_ibu': namaIbu,
            'id_alamat': idAlamat,
          })
          .select('id')
          .maybeSingle();
      return res?['id'] as int?;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /* ----------------------------------------------------------
   *  AREA WALI (opsional)
   * ---------------------------------------------------------- */
  Future<int?> insertWali({required String namaWali, int? idAlamat}) async {
    try {
      final res = await _client
          .from('wali')
          .insert({'nama_wali': namaWali, 'id_alamat': idAlamat})
          .select('id')
          .maybeSingle();
      return res?['id'] as int?;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /* ----------------------------------------------------------
   *  AREA AGAMA
   * ---------------------------------------------------------- */
  Future<int?> getAgamaId(String namaAgama) async {
    try {
      final res = await _client
          .from('agama')
          .select('id')
          .eq('nama_agama', namaAgama)
          .maybeSingle();
      return res?['id'] as int?;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /* ----------------------------------------------------------
   *  AREA WILAYAH → autocomplete dusun
   * ---------------------------------------------------------- */
  Future<List<DusunItemModel>> getDusunSuggestions(String query) async {
    try {
      final res = await _client
          .from('search_dusun_full')
          .select()
          .or('nama_dusun.ilike.%$query%,nama_desa.ilike.%$query%')
          .limit(10);
      return res.map((e) => DusunItemModel.fromMap(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<Map<String, dynamic>?> getDusunDetails(String namaDusun) async {
    try {
      final res = await _client
          .from('search_dusun_full')
          .select()
          .eq('nama_dusun', namaDusun)
          .maybeSingle();
      return res;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
