import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/db_helper.dart';

class TambahCatatanPage extends StatefulWidget {
  final Map<String, dynamic>? catatanUntukEdit;

  const TambahCatatanPage({Key? key, this.catatanUntukEdit}) : super(key: key);

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryGreen = const Color(0xFF27AE60);

  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  String _selectedAktivitas = 'Penanaman';
  bool _isEditMode = false;

  final List<String> _kategoriAktivitas = [
    'Penanaman',
    'Penyiraman',
    'Pemupukan',
    'Pengendalian Hama',
    'Panen'
  ];

  @override
  void initState() {
    super.initState();
    
    if (widget.catatanUntukEdit != null) {
      _isEditMode = true;
      var data = widget.catatanUntukEdit!;
      _selectedAktivitas = data['jenis_aktivitas'] ?? 'Penanaman';
      _catatanController.text = data['catatan'] ?? '';
      _lokasiController.text = data['lokasi'] ?? '';
      _tanggalController.text = data['tanggal'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      _waktuController.text = data['waktu'] ?? DateFormat('HH:mm').format(DateTime.now());
    } else {
      _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _waktuController.text = DateFormat('HH:mm').format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    _lokasiController.dispose();
    _tanggalController.dispose();
    _waktuController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pilihWaktu() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final sekarang = DateTime.now();
        final formatWaktu = DateTime(sekarang.year, sekarang.month, sekarang.day, picked.hour, picked.minute);
        _waktuController.text = DateFormat('HH:mm').format(formatWaktu);
      });
    }
  }

  Future<void> _simpanCatatan() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> dataCatatan = {
        'jenis_aktivitas': _selectedAktivitas,
        'catatan': _catatanController.text.trim(),
        'lokasi': _lokasiController.text.trim(),
        'tanggal': _tanggalController.text,
        'waktu': _waktuController.text,
      };

      try {
        if (_isEditMode) {
          int idCatatan = widget.catatanUntukEdit!['id_catatan'];
          dataCatatan['id_catatan'] = idCatatan;
          
          // SOLUSI SINKRONISASI PARAMETER DATABASE: mengirimkan idCatatan dan dataCatatan
          await DBHelper.updateCatatan(idCatatan, dataCatatan); 

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Catatan berhasil diperbarui!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context, dataCatatan);
          }
        } else {
          await DBHelper.insertCatatan(dataCatatan);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Catatan berhasil disimpan!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          _isEditMode ? "Edit Catatan" : "Tambah Catatan Baru",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Jenis Aktivitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedAktivitas,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _kategoriAktivitas.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAktivitas = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text("Isi Catatan / Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Misal: Memberikan pupuk NPK 50gram per pohon...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Catatan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              const Text("Lokasi Lahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  hintText: "Misal: Blok A / Kebun Belakang",
                  prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _tanggalController,
                          readOnly: true,
                          onTap: _pilihTanggal,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Waktu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _waktuController,
                          readOnly: true,
                          onTap: _pilihWaktu,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _simpanCatatan,
                  child: Text(
                    _isEditMode ? "Perbarui Catatan" : "Simpan Catatan",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}