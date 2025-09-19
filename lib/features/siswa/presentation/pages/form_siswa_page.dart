import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_4/features/siswa/data/models/dusun_item_model.dart';
import 'package:project_4/features/siswa/presentation/widgets/form_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/toast.dart';
import '../../../../features/siswa/data/models/siswa_model.dart';
import '../../../../features/siswa/presentation/providers/siswa_form_provider.dart';
import '../../../../features/siswa/domain/repositories/siswa_repository.dart';

class FormSiswaPage extends StatelessWidget {
  final SiswaModel? siswa;
  const FormSiswaPage({super.key, this.siswa});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SiswaFormProvider(),
      child: _FormSiswaBody(siswa: siswa),
    );
  }
}

class _FormSiswaBody extends StatefulWidget {
  final SiswaModel? siswa;
  const _FormSiswaBody({this.siswa});

  @override
  State<_FormSiswaBody> createState() => _FormSiswaBodyState();
}

class _FormSiswaBodyState extends State<_FormSiswaBody> {
  /* --------------------------------------------------------------------------
   *  CONTROLLER
   * -------------------------------------------------------------------------- */
  final _nisnC = TextEditingController();
  final _namaC = TextEditingController();
  final _tempatLahirC = TextEditingController();
  final _tanggalLahirC = TextEditingController();
  final _noHpC = TextEditingController();
  final _nikC = TextEditingController();
  final _jalanC = TextEditingController();
  final _rtC = TextEditingController();
  final _rwC = TextEditingController();
  final _dusunC = TextEditingController();
  final _desaC = TextEditingController();
  final _kecamatanC = TextEditingController();
  final _kabupatenC = TextEditingController();
  final _provinsiC = TextEditingController();
  final _kodePosC = TextEditingController();
  final _ayahC = TextEditingController();
  final _ibuC = TextEditingController();
  final _waliC = TextEditingController();
  final _alamatOrtuC = TextEditingController();

  late SiswaFormProvider _formProv;
  late SiswaRepository _repo;

  int _currentStep = 0;
  // final bool _isLoadingSuggestions = false;
  late List<DusunItemModel> _dusunList = [];
  late final Future<void>? _loadData;

  /* --------------------------------------------------------------------------
   *  INITIALISASI
   * -------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    _formProv = context.read<SiswaFormProvider>();
    _repo = context.read<SiswaRepository>();

    _loadDusun();

    if (widget.siswa != null) {
      _loadData = _loadExistingData(widget.siswa!);
    } else {
      _loadData = null; // mode tambah baru
    }
  }

  Future<void> _loadDusun() async {
    final list = await _repo.getDusunSuggestions('');
    setState(() => _dusunList = list);
  }

  @override
  void dispose() {
    _nisnC.dispose();
    _namaC.dispose();
    _tempatLahirC.dispose();
    _tanggalLahirC.dispose();
    _noHpC.dispose();
    _nikC.dispose();
    _jalanC.dispose();
    _rtC.dispose();
    _rwC.dispose();
    _dusunC.dispose();
    _desaC.dispose();
    _kecamatanC.dispose();
    _kabupatenC.dispose();
    _provinsiC.dispose();
    _kodePosC.dispose();
    _ayahC.dispose();
    _ibuC.dispose();
    _waliC.dispose();
    _alamatOrtuC.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData(SiswaModel s) async {
    // --- step 0 & 3 (sudah ada) ---
    _nisnC.text = s.nisn;
    _namaC.text = s.namaLengkap;
    _formProv.agamaNama = s.namaAgama;
    _formProv.jenisKelamin = s.jenisKelamin;
    _tempatLahirC.text = s.tempatLahir;
    _tanggalLahirC.text = DateFormat('dd-MM-yyyy').format(s.tanggalLahir);
    _noHpC.text = s.noHp;
    _nikC.text = s.nik;
    _ayahC.text = s.namaAyah;
    _ibuC.text = s.namaIbu;
    _waliC.text = s.namaWali ?? '';
    _alamatOrtuC.text = s.alamatOrtu ?? '';

    // ➜ langsung pakai id_dusun & teks dari view (sudah tersedia)
    _dusunC.text = s.namaDusun;
    _desaC.text = s.namaDesa;
    _kecamatanC.text = s.namaKecamatan;
    _kabupatenC.text = s.namaKabupaten;
    _provinsiC.text = s.namaProvinsi;
    _kodePosC.text = s.kodePos;

    final idDus = s.idDusun; // int?
    if (idDus == null) {
      // kalau view tidak mengembalikan id_dusun, ambil via API
      final dusDetail = await _repo.getDusunDetails(s.namaDusun);
      _formProv.idDusun = dusDetail?['id_dusun'] as int?;
    } else {
      _formProv.idDusun = idDus;
    }

    // baru masukkan ke provider
    _formProv.setAlamat(
      jalan: s.jalanAlamat,
      rt: s.rtAlamat.toString(),
      rw: s.rwAlamat.toString(),
      idDusun: _formProv.idDusun,
      silent: true,
    );

    // ➜ ambil JALAN/RT/RW via API kalau idAlamat tersedia
    if (s.idAlamat != null) {
      final alamat = await _repo.getAlamatSiswa(s.idAlamat!);
      if (alamat != null) {
        _jalanC.text = alamat['jalan_alamat'] ?? '';
        _rtC.text = alamat['rt_alamat']?.toString() ?? '';
        _rwC.text = alamat['rw_alamat']?.toString() ?? '';
      }
    } else {
      // kosongkan saja (mode tambah atau data tidak lengkap)
      _jalanC.clear();
      _rtC.clear();
      _rwC.clear();
    }

    // alamat & wilayah akan di-load ulang lewat view v_siswa_full
    // karena kita hanya menyimpan id di DB
  }

  /* --------------------------------------------------------------------------
   *  NAVIGASI STEP
   * -------------------------------------------------------------------------- */
  void _nextStep() {
    if (!_validateCurrentStep()) return;
    setState(() => _currentStep++);
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_nisnC.text.isEmpty ||
            _namaC.text.isEmpty ||
            _formProv.jenisKelamin == null ||
            _formProv.agamaNama == null ||
            _tempatLahirC.text.isEmpty ||
            _tanggalLahirC.text.isEmpty ||
            _noHpC.text.isEmpty ||
            _nikC.text.isEmpty) {
          Toast.warning(context, 'Lengkapi semua field data pribadi');
          return false;
        }
        return true;
      case 1:
        if (_jalanC.text.isEmpty ||
            _rtC.text.isEmpty ||
            _rwC.text.isEmpty ||
            _formProv.idDusun == null) {
          Toast.warning(context, 'Lengkapi alamat & pilih dusun');
          return false;
        }
        return true;
      case 2:
        if (_ayahC.text.isEmpty ||
            _ibuC.text.isEmpty ||
            _alamatOrtuC.text.isEmpty) {
          Toast.warning(context, 'Lengkapi data orang tua / wali');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  /* --------------------------------------------------------------------------
   *  SUBMIT
   * -------------------------------------------------------------------------- */
  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;

    _formProv.setLoading(true);

    try {
      // 1. Agama
      final idAgama = await _repo.getAgamaId(_formProv.agamaNama!);
      if (idAgama == null) {
        Toast.error(context, 'Agama tidak ditemukan');
        return;
      }

      // 2. Alamat
      final idAlamat = await _repo.insertAlamat(
        jalan: _jalanC.text,
        rt: int.parse(_rtC.text),
        rw: int.parse(_rwC.text),
        idDusun: _formProv.idDusun!,
      );
      if (idAlamat == null) throw Exception('Gagal menyimpan alamat');

      // 3. Orang Tua
      final idOrangTua = await _repo.insertOrangTua(
        namaAyah: _ayahC.text,
        namaIbu: _ibuC.text,
        idAlamat: null, // opsional
      );
      if (idOrangTua == null) throw Exception('Gagal menyimpan orang tua');

      // 4. Wali (opsional)
      int? idWali;
      if (_waliC.text.isNotEmpty) {
        idWali = await _repo.insertWali(namaWali: _waliC.text, idAlamat: null);
      }

      // 5. Siswa
      final data = {
        'nisn': _nisnC.text,
        'nama_lengkap': _namaC.text,
        'jenis_kelamin': _formProv.jenisKelamin,
        'id_agama': idAgama,
        'tempat_lahir': _tempatLahirC.text,
        'tanggal_lahir': DateFormat(
          'dd-MM-yyyy',
        ).parse(_tanggalLahirC.text).toIso8601String(),
        'no_hp': _noHpC.text,
        'nik': _nikC.text,
        'id_alamat': idAlamat,
        'id_orang_tua': idOrangTua,
        'id_wali': idWali,
      };

      if (widget.siswa == null) {
        await _repo.insertSiswa(data);
        Toast.success(context, 'Siswa berhasil ditambahkan');
      } else {
        await _repo.updateSiswa(widget.siswa!.id!, data);
        Toast.success(context, 'Siswa berhasil diperbarui');
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      Toast.error(context, e.toString());
    } finally {
      _formProv.setLoading(false);
    }
  }

  /* --------------------------------------------------------------------------
   *  WIDGET BUILD
   * -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.siswa == null ? 'Tambah Siswa' : 'Edit Siswa'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      body: (_loadData == null)
          ? _buildBodyContent()
          : FutureBuilder<void>(
              future: _loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Gagal memuat: ${snapshot.error}'));
                }
                return _buildBodyContent(); // data sudah terisi
              },
            ),
    );
  }

  Widget _buildBodyContent() {
    return Consumer<SiswaFormProvider>(
      builder: (_, form, __) => Column(
        children: [
          _buildStepIndicator(),
          Expanded(child: _buildStepContent()),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final labels = ['Data Pribadi', 'Alamat', 'Orang Tua / Wali'];
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(3, (i) {
          final active = _currentStep == i;
          final done = _currentStep > i;
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: done || active
                        ? const Color(0xFF3B82F6)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    done ? Icons.check : Icons.looks_one_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: active ? const Color(0xFF3B82F6) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _stepDataPribadi();
      case 1:
        return _stepAlamat();
      case 2:
        return _stepOrangTua();
      default:
        return _stepDataPribadi();
    }
  }

  Widget _stepDataPribadi() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          modernTextField(
            controller: _nisnC,
            label: 'NISN',
            keyboardType: TextInputType.number,
            validator: (s) => s!.length < 10 ? 'NISN 10 digit' : null,
          ),
          SizedBox(height: 10,),
          modernTextField(controller: _namaC, label: 'Nama Lengkap'),
          SizedBox(height: 10,),
          modernDropdown(
            label: 'Jenis Kelamin',
            value: _formProv.jenisKelamin,
            items: const ['Laki-laki', 'Perempuan'],
            onChanged: (v) => setState(() => _formProv.jenisKelamin = v),
          ),
          SizedBox(height: 10,),
          modernDropdown(
            label: 'Agama',
            value: _formProv.agamaNama,
            items: const [
              'Islam',
              'Kristen',
              'Katolik',
              'Hindu',
              'Buddha',
              'Konghucu',
            ],
            onChanged: (v) => setState(() => _formProv.agamaNama = v),
          ),
          SizedBox(height: 10,),
          modernTextField(controller: _tempatLahirC, label: 'Tempat Lahir'),
          SizedBox(height: 10,),
          modernDateField(controller: _tanggalLahirC, label: 'Tanggal Lahir', context: context),
          SizedBox(height: 10,),
          modernTextField(
            controller: _noHpC,
            label: 'No HP',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 10,),
          modernTextField(
            controller: _nikC,
            label: 'NIK',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }

  Widget _stepAlamat() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          modernTextField(controller: _jalanC, label: 'Jalan / Nomor Rumah'),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: modernTextField(
                  controller: _rtC,
                  label: 'RT',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: modernTextField(
                  controller: _rwC,
                  label: 'RW',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          _autocompleteDusun(),
          SizedBox(height: 10,),
          modernTextField(controller: _desaC, label: 'Desa', readOnly: true),
          SizedBox(height: 10,),
          modernTextField(
            controller: _kecamatanC,
            label: 'Kecamatan',
            readOnly: true,
          ),
          SizedBox(height: 10,),
          modernTextField(
            controller: _kabupatenC,
            label: 'Kabupaten',
            readOnly: true,
          ),
          SizedBox(height: 10,),
          modernTextField(controller: _provinsiC, label: 'Provinsi', readOnly: true),
          SizedBox(height: 10,),
          modernTextField(
            controller: _kodePosC,
            label: 'Kode Pos',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _stepOrangTua() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          modernTextField(controller: _ayahC, label: 'Nama Ayah'),
          SizedBox(height: 10,),
          modernTextField(controller: _ibuC, label: 'Nama Ibu'),
          SizedBox(height: 10,),
          modernTextField(controller: _waliC, label: 'Nama Wali (opsional)'),
          const SizedBox(height: 8),
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Samakan dengan alamat siswa'),
              onPressed: () {
                final alamat =
                    "${_jalanC.text}, RT ${_rtC.text}/RW ${_rwC.text}, Dusun ${_dusunC.text}, Desa ${_desaC.text}, Kec. ${_kecamatanC.text}, Kab. ${_kabupatenC.text}, ${_provinsiC.text} ${_kodePosC.text}";
                _alamatOrtuC.text = alamat;
              },
            ),
          ),
          SizedBox(height: 10,),
          modernTextField(
            controller: _alamatOrtuC,
            label: 'Alamat Orang Tua / Wali',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _autocompleteDusun() {
    return Autocomplete<DusunItemModel>(
      optionsBuilder: (TextEditingValue v) {
        if (v.text.isEmpty) return const Iterable<DusunItemModel>.empty();
        return _dusunList.where(
          (d) =>
              d.namaDusun.toLowerCase().contains(v.text.toLowerCase()) ||
              d.namaDesa.toLowerCase().contains(v.text.toLowerCase()),
        );
      },
      displayStringForOption: (d) => d.display, // ➜ "Krajan • Kromengan"
      onSelected: (d) => setState(() {
        _dusunC.text = d.namaDusun;
        _formProv.idDusun = d.idDusun;
        _desaC.text = d.namaDesa;
        _kecamatanC.text = d.namaKecamatan;
        _kabupatenC.text = d.namaKabupaten;
        _provinsiC.text = d.namaProvinsi;
        _kodePosC.text = d.kodePos;
      }),
      fieldViewBuilder: (ctx, controller, node, onSubmit) {
        if (controller.text.isEmpty && _dusunC.text.isNotEmpty) {
          controller.text = _dusunC.text;
        }
        return modernTextField(
          controller: controller,
          label: 'Dusun',
          suffixIcon: null,
          focusNode: node,
        );
      },
    );
  }

  Widget _buildNavigationButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                child: const Text('Sebelumnya'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: Consumer<SiswaFormProvider>(
              builder: (_, form, __) => ElevatedButton(
                onPressed: form.isLoading
                    ? null
                    : (_currentStep == 2 ? _submit : _nextStep),
                child: form.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_currentStep == 2 ? 'Simpan' : 'Berikutnya'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
