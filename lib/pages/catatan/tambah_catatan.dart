import 'package:flutter/material.dart';
import '../../database/db_helper.dart';

class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({Key? key}) : super(key: key);

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);

  // 1. CONTROLLER UNTUK MENANGKAP INPUTAN TEKS
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();       // Untuk judul singkat, ex: "Urea 50 kg/ha"
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _detailCatatanController = TextEditingController(); // Untuk teks panjang

  // 2. VARIABLE UNTUK DROPDOWN AKTIVITAS
  String? _selectedAktivitas = 'Pemupukan'; // Default value
  final List<String> _listAktivitas = [
    'Penanaman', 
    'Penyiraman', 
    'Pemupukan', 
    'Pengendalian Hama', 
    'Panen'
  ];

  // Fungsi untuk memunculkan pemilih Tanggal
  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format sederhana DD-MM-YYYY (Bisa disesuaikan pakai package intl nantinya)
        _tanggalController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Fungsi untuk memunculkan pemilih Waktu
  Future<void> _pilihWaktu() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Format jam HH:MM
        _waktuController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // 3. FUNGSI MENYIMPAN DATA KE SQLITE
  Future<void> _simpanData() async {
    // Validasi sederhana, pastikan data penting tidak kosong
    if (_tanggalController.text.isEmpty || _catatanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan Judul Catatan harus diisi!')),
      );
      return;
    }

    // Membungkus data sesuai struktur tabel SQLite di DBHelper
    Map<String, dynamic> dataCatatan = {
      // id_user: 1, // Jika nanti ada fitur login, bisa dimasukkan id_user di sini
      'jenis_aktivitas': _selectedAktivitas,
      'catatan': _catatanController.text,
      'detail_catatan': _detailCatatanController.text,
      'lokasi': _lokasiController.text,
      'tanggal': _tanggalController.text, // Idealnya format YYYY-MM-DD agar mudah di-sort
      'waktu': _waktuController.text,
      'foto': '', // Dikosongkan sementara sampai fitur kamera dibuat
      'created_at': DateTime.now().toString(),
    };

    // Panggil fungsi insert dari DBHelper
    await DBHelper.insertCatatan(dataCatatan);

    // Tampilkan notifikasi sukses
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan!'), backgroundColor: Colors.green),
      );
      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  // WIDGET BANTUAN: LABEL
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
    );
  }

  // WIDGET BANTUAN: TEXTFIELD
  Widget _buildTextField({required TextEditingController controller, String? hintText, int maxLines = 1, int? maxLength, bool readOnly = false, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryGreen)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28), onPressed: () => Navigator.pop(context)),
        title: Text("Tambah Catatan", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TANGGAL & WAKTU (Bisa diklik muncul kalender/jam)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tanggal"),
                      _buildTextField(controller: _tanggalController, hintText: "Pilih Tanggal", readOnly: true, onTap: _pilihTanggal),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Waktu"),
                      _buildTextField(controller: _waktuController, hintText: "Pilih Waktu", readOnly: true, onTap: _pilihWaktu),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. AKTIVITAS (Dropdown)
            _buildLabel("Aktivitas"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAktivitas,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: _listAktivitas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                            // Untuk sementara pakai icon yang sama, nanti bisa dibuat dinamis per jenis
                            child: const Icon(Icons.eco, color: Colors.white, size: 16), 
                          ),
                          const SizedBox(width: 12),
                          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAktivitas = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. CATATAN SINGKAT
            _buildLabel("Catatan"),
            _buildTextField(controller: _catatanController, hintText: "Misal: Urea 50 kg/ha"),
            const SizedBox(height: 20),

            // 4. LOKASI
            _buildLabel("Lokasi"),
            _buildTextField(controller: _lokasiController, hintText: "Misal: Sawah Blok B"),
            const SizedBox(height: 20),

            // 5. DETAIL CATATAN (Teks Panjang)
            _buildLabel("Detail Catatan"),
            _buildTextField(controller: _detailCatatanController, hintText: "Ceritakan detail aktivitasmu di sini...", maxLines: 4, maxLength: 200),
            const SizedBox(height: 20),

            // 6. FOTO
            _buildLabel("Foto"),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 80, width: 120,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: primaryGreen, size: 32),
                        const SizedBox(height: 4),
                        const Text("Tambah Foto", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 80, width: 120, color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey, size: 40), 
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 7. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _simpanData, // MEMANGGIL FUNGSI SIMPAN KE SQLITE
                child: const Text("Simpan Catatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}