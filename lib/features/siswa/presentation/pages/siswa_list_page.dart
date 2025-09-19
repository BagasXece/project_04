import 'package:flutter/material.dart';
import 'package:project_4/features/siswa/domain/repositories/siswa_repository_impl.dart';
import 'package:provider/provider.dart';
import '../../../siswa/data/datasources/siswa_remote_datasource.dart';
import '../../../siswa/presentation/pages/form_siswa_page.dart';
import '../../../siswa/presentation/providers/siswa_list_provider.dart';

class SiswaListPage extends StatefulWidget {
  const SiswaListPage({super.key});

  @override
  State<SiswaListPage> createState() => _SiswaListPageState();
}

class _SiswaListPageState extends State<SiswaListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SiswaListProvider(
        repository: SiswaRepositoryImpl(SiswaRemoteDataSource()),
      )..loadSiswa(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Siswa'),
          backgroundColor: const Color(0xFF1E40AF),
        ),
        body: Consumer<SiswaListProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.siswaList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data siswa',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan tombol + untuk menambah siswa baru',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.loadSiswa,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.siswaList.length,
                itemBuilder: (context, index) {
                  final siswa = provider.siswaList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            siswa.namaLengkap[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        siswa.namaLengkap,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('NISN: ${siswa.nisn}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FormSiswaPage(siswa: siswa),
                              ),
                            );
                            if (mounted) provider.loadSiswa();
                          } else if (value == 'delete') {
                            _showDeleteDialog(context, provider, siswa.id!);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Color(0xFF2563EB)),
                                SizedBox(width: 12),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Color(0xFFEF4444)),
                                SizedBox(width: 12),
                                Text('Hapus'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormSiswaPage()),
            );
            context.read<SiswaListProvider>().loadSiswa();
          },
          backgroundColor: const Color(0xFF3B82F6),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SiswaListProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[600]),
            const SizedBox(width: 12),
            const Text('Konfirmasi Hapus'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteSiswa(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}